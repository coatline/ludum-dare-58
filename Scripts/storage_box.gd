extends HoldableObject
class_name StorageBox

func use(direction: Vector3, delta: float, started: bool = false, finished: bool = false) -> void:
	pass

func _exit_tree():
	destroyed.emit()

func useable() -> bool: return false
func rotate_vertically() -> bool: return true


func interact(interactor: PlayerInteractor):
	var card: CardObject = interactor.object_holder.holdable_object as CardObject
	
	if card:
		var type: CardType = card.card_type
		Utils.play_sound_at("ThrowObject", Vector2.ZERO, 1, false)
		card.queue_free()
	else:
		interactor.object_holder.pickup(self)
		current_holder = interactor.object_holder
		Utils.play_sound_at("PickupObject", Vector2.ZERO, 1, false)

func can_interact(interactor: PlayerInteractor) -> bool:
	if interactor.object_holder.has_item():
		var card: CardObject = interactor.object_holder.holdable_object as CardObject
		return card != null
	return true

func interact_text(interactor: PlayerInteractor) -> String:
	
	var card: CardObject = interactor.object_holder.holdable_object as CardObject
	
	if card == null:
		return Utils.get_verb_item_string("Pickup ", self)

	var type: CardType = card.card_type
	
	return "Store [color=%s]%s[/color]" % [
	card.text_color().to_html(),
	type.display_name()
]

func text_color() -> Color: return Color.BROWN
