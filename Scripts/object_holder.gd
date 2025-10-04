class_name ObjectHolder
extends Node3D

@export var hand: Node3D

var holdable_object: HoldableObject = null

func pickup(obj):
	holdable_object = obj
	holdable_object.pickup()
	
	holdable_object.left_hand.connect(object_gone)
	holdable_object.destroyed.connect(object_gone)

func object_gone():
	if holdable_object:
		holdable_object.left_hand.disconnect(object_gone)
		holdable_object.destroyed.disconnect(object_gone)
		holdable_object = null

func try_drop():
	if holdable_object:
		holdable_object.drop(-global_transform.basis.z)
		#SoundManager.play_sound("DropObject", hand.global_transform.origin)

func try_use(delta: float, started: bool = false, finished: bool = false) -> void:
	if holdable_object:
		holdable_object.use(-global_transform.basis.z, delta, started, finished)

func _process(_delta):
	if holdable_object:
		var rot_x = 0
		if holdable_object.rotate_vertically:
			rot_x = hand.global_rotation_degrees.x
		var rot = Vector3(rot_x, hand.global_rotation_degrees.y, hand.global_rotation_degrees.z)
		holdable_object.hold(hand.global_transform.origin, rot)

func has_item() -> bool: return holdable_object != null
