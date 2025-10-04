extends HoldableObject

const CARD: PackedScene = preload("uid://dv7rsc3ce2imj")

@export var pack_type: CardPackType = null
var open_amount: float = 0

func set_type(type: CardPackType):
	display_name = pack_type.display_name()
	pack_type = type

func _ready() -> void:
	if pack_type:
		set_type(pack_type)

func use(direction: Vector3, delta: float, started: bool = false, finished: bool = false) -> void:
	if finished:
		open_amount = 0
		return
	
	open_amount += delta
	
	if open_amount >= pack_type.open_time:
		open()

func open():
	for i in range(pack_type.card_count):
		var card_instance: CardObject = CARD.instantiate()
		get_parent().add_child(card_instance)
		card_instance.global_transform.origin = global_transform.origin
		var card_type = ResourceManager.get_random_resource(CardType)
		card_instance.set_card_type(card_type)
	
	queue_free()

func useable() -> bool: return true
