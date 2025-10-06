extends HoldableObject
class_name Box

func use(direction: Vector3, delta: float, started: bool = false, finished: bool = false) -> void:
	
	pass

func _exit_tree():
	destroyed.emit()

func useable() -> bool: return false
func rotate_vertically() -> bool: return true
func text_color() -> Color: return Color.DARK_SALMON
func use_text() -> String: return Utils.get_verb_item_string("Use ", self)
func interact_text(interactor: PlayerInteractor) -> String: return Utils.get_verb_item_string("Pickup ", self)
