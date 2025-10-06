extends UIOverlay
class_name ShopUI

const SHOP_OPTION = preload("uid://b838i3tsnqtqb")
const MAX_OFFERS = 6

@export var offers_container: GridContainer
@export var available_items: Array[ItemType] = [] 
@export var new_offer_chance: float = 0.1
@export var max_offer_duration: float = 60.0
@export var min_offer_duration: float = 60.0

func _ready():
	var num_offers = randi_range(MAX_OFFERS / 4, MAX_OFFERS / 2)
	
	for i in range(num_offers):
		offer_random()

func offer_random():
	var item_type: ItemType = available_items[randi_range(0, len(available_items) - 1)]
	create_offer(item_type)

func create_offer(item_type: ItemType):
	var new_offer: ShopOffer = SHOP_OPTION.instantiate()
	var price: float = Economy.get_market_price(item_type.rarity) * randf_range(0.5, 1.2)
	var pack: CardPackType = item_type as CardPackType
	
	if pack:
		price += pack.price
	
	offers_container.add_child(new_offer)
	new_offer.setup_offer(item_type, price, randf_range(min_offer_duration, max_offer_duration))

func _process(delta: float) -> void:
	if offers_container.get_child_count() < MAX_OFFERS:
		if randf() < new_offer_chance * delta * TimeManager.time_scale:
			offer_random()
