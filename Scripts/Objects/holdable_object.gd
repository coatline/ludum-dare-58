extends Interactable
class_name HoldableObject

signal picked_up
signal left_hand
signal destroyed

@export var rb: RigidBody3D
@export var collider: CollisionShape3D
@export var display_name: String

var being_held: bool = false
var current_holder: Node = null

func pickup():
	collider.disabled = true
	rb.linear_velocity = Vector3.ZERO
	rb.angular_velocity = Vector3.ZERO

	rb.contact_monitor = false
	rb.gravity_scale = 0.0

	being_held = true
	picked_up.emit()

func drop(direction: Vector3, force: float):
	leave_hand()
	rb.linear_velocity = direction.normalized() * force

func leave_hand():
	collider.disabled = false
	rb.contact_monitor = true
	rb.gravity_scale = 1.0

	being_held = false
	current_holder = null
	left_hand.emit()

func hold(pos: Vector3, rot: Vector3):
	being_held = true
	global_transform.origin = pos
	rotation_degrees = rot

func interact(interactor):
	interactor.object_holder.pickup(self)
	current_holder = interactor.object_holder

func can_interact(interactor) -> bool:
	return not interactor.object_holder.has_item()

func use(direction: Vector3, delta: float, started: bool = false, finished: bool = false) -> void:
	pass

func _exit_tree():
	destroyed.emit()

func useable() -> bool: return false
func rotate_vertically() -> bool: return true
func text_color() -> Color: return Color.DARK_SALMON
func use_text() -> String: return Utils.get_verb_item_string("Use ", self)
func interact_text(interactor: PlayerInteractor) -> String: return Utils.get_verb_item_string("Pickup ", self)
