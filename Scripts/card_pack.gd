extends HoldableObject

const CARD: PackedScene = preload("uid://dv7rsc3ce2imj")

var openAmount: float = 0

func use(direction: Vector3, delta: float, started: bool = false, finished: bool = false) -> void:
	if finished:
		openAmount = 0
		return
	
	openAmount += delta
	
	if openAmount >= 1:
		open()

func open():
	for i in range(5):
		var card_instance: CardObject = CARD.instantiate()
		get_parent().add_child(card_instance)
		card_instance.global_transform.origin = global_transform.origin
		var card_type = ResourceManager.get_random_resource(CardType)
		print(card_type.resource_path.get_file().get_basename())
		card_instance.set_card_type(card_type)
	queue_free()

func useable() -> bool: return true
