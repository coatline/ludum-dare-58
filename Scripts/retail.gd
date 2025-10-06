extends Control
class_name Retail

@export var retail_offer_scene: PackedScene
@export var offers_container: GridContainer
@export var available_items: Array[ItemType] = [] 
@export var max_price_duration: float = 1440.0
@export var min_price_duration: float = 60.0

var item_to_ui: Dictionary[ItemType, ShopOffer] = {}
var price_update_timer: float = 0.0

func _ready():
	for item in available_items:
		create_offer(item)
	
	price_update_timer = randf_range(min_price_duration, max_price_duration)

func create_offer(item_type: ItemType):
	var new_offer: ShopOffer = retail_offer_scene.instantiate()
	var price: float = Economy.get_market_price(item_type.rarity) * randf_range(0.5, 1.2)
	var pack: CardPackType = item_type as CardPackType
	
	if pack:
		price += pack.price
	
	offers_container.add_child(new_offer)
	new_offer.setup_offer(item_type, price)
	item_to_ui[item_type] = new_offer

func _process(delta: float) -> void:
	price_update_timer -= delta * TimeManager.time_scale
	if price_update_timer <= 0:
		price_update_timer = randf_range(min_price_duration, max_price_duration)

		for item in available_items:
			create_offer(item)

			var price: float = Economy.get_market_price(item.rarity) * randf_range(1, 1.5)
			var pack: CardPackType = item as CardPackType
			if pack:
				price += pack.price
			item_to_ui[item].set_price(price)
