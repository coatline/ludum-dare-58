extends Interactable
class_name HoldableObject

signal picked_up
signal left_hand
signal destroyed

@export var rb: RigidBody3D
@export var drop_force: float = 10.0

var being_held: bool = false
var current_holder: Node = null

# --- Pickup / Drop ---

func pickup():
	if not rb:
		return
	rb.linear_velocity = Vector3.ZERO
	rb.angular_velocity = Vector3.ZERO

	rb.contact_monitor = false
	rb.gravity_scale = 0.0

	being_held = true
	emit_signal("picked_up")

func drop(direction: Vector3):
	leave_hand()
	if rb:
		rb.linear_velocity = direction.normalized() * drop_force

func leave_hand():
	if not rb:
		return
	rb.contact_monitor = true
	rb.gravity_scale = 1.0

	being_held = false
	current_holder = null
	emit_signal("left_hand")

func hold(position: Vector3, rotation: Vector3):
	being_held = true
	global_transform.origin = position
	rotation_degrees = rotation

func interact(interactor):
	print()
	#if interactor.has_propert("object_holder"):
	interactor.object_holder.pickup(self)
	current_holder = interactor.object_holder

func can_interact(interactor) -> bool:
	return not interactor.object_holder.has_item() if interactor.has_method("object_holder") else false

func interact_text() -> String:
	return "Pickup " + name

func start_using(direction: Vector3) -> void:
	pass

func continue_using(direction: Vector3) -> void:
	pass

func finish_using(direction: Vector3) -> void:
	pass

# --- Properties ---
func rotate_vertically() -> bool:
	return false

# --- Destruction ---
func _exit_tree():
	emit_signal("destroyed")
