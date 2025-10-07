extends Control
class_name Marketplace

const SHOP_OPTION = preload("uid://b838i3tsnqtqb")
const MAX_OFFERS = 6

@export var offers_container: GridContainer
@export var new_offer_chance: float = 0.1
@export var max_offer_duration: float = 60.0
@export var min_offer_duration: float = 60.0

var available_items := []

func _ready():
	var num_offers = randi_range(MAX_OFFERS / 4, MAX_OFFERS / 2)

	available_items = ItemLibrary.cards.unsorted_array.duplicate()
	available_items.append_array(ItemLibrary.card_packs.unsorted_array.duplicate())

	for i in range(num_offers):
		offer_random()

func offer_random():
	var item_type: ItemType = available_items[randi_range(0, len(available_items) - 1)]
	create_offer(item_type)

func create_offer(item_type: ItemType):
	var new_offer: MarketplaceOptionUI = SHOP_OPTION.instantiate()
	var card: CardType = item_type as CardType
	var price: float = item_type.price * randf_range(0.7, 1.15)
	
	if card:
		price = Economy.card_to_market[card].current_price
	
	offers_container.add_child(new_offer)
	new_offer.setup_offer(item_type, price)
	new_offer.set_duration(randf_range(min_offer_duration, max_offer_duration))

func _process(delta: float) -> void:
	if offers_container.get_child_count() < MAX_OFFERS:
		if randf() < new_offer_chance * delta * TimeManager.time_scale:
			offer_random()
