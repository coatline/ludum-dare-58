extends Interactable
class_name HoldableObject

signal picked_up
signal left_hand
signal destroyed

@export var rb: RigidBody3D
@export var drop_force: float = 10.0
@export var collider: CollisionShape3D

var being_held: bool = false
var current_holder: Node = null

# --- Pickup / Drop ---

func pickup():
	collider.disabled = true
	rb.linear_velocity = Vector3.ZERO
	rb.angular_velocity = Vector3.ZERO

	rb.contact_monitor = false
	rb.gravity_scale = 0.0

	being_held = true
	picked_up.emit()

func drop(direction: Vector3):
	leave_hand()
	rb.linear_velocity = direction.normalized() * drop_force

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
	return not interactor.object_holder.has_item() if interactor.has_method("object_holder") else false

func interact_text() -> String:
	return "Pickup " + name

func start_using(direction: Vector3) -> void:
	pass

func continue_using(direction: Vector3) -> void:
	pass

func finish_using(direction: Vector3) -> void:
	pass

func rotate_vertically() -> bool:
	return false

func _exit_tree():
	emit_signal("destroyed")
