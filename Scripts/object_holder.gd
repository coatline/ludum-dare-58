class_name ObjectHolder
extends Node3D

@export var hand: Node3D

var holdable_object: Node = null

func pickup(obj):
	#SoundManager.play_sound("PickupObject", global_transform.origin)
	holdable_object = obj
	holdable_object.pickup()
	
	if holdable_object.has_signal("left_hand"):
		holdable_object.connect("left_hand", Callable(self, "_holdable_object_left_hand"))
	if holdable_object.has_signal("destroyed"):
		holdable_object.connect("destroyed", Callable(self, "_holdable_object_left_hand"))

func _holdable_object_left_hand():
	if holdable_object:
		if holdable_object.is_connected("left_hand", _holdable_object_left_hand):
			holdable_object.disconnect("left_hand", _holdable_object_left_hand)
		if holdable_object.is_connected("destroyed", _holdable_object_left_hand):
			holdable_object.disconnect("destroyed", _holdable_object_left_hand)
		holdable_object = null

func try_drop():
	if holdable_object:
		holdable_object.drop(-global_transform.basis.z)
		#SoundManager.play_sound("DropObject", hand.global_transform.origin)

func start_using():
	if holdable_object:
		holdable_object.start_using(global_transform.basis.z * -1)

func continue_using():
	if holdable_object:
		holdable_object.continue_using(global_transform.basis.z * -1)

func finish_using():
	if holdable_object:
		holdable_object.finish_using(global_transform.basis.z * -1)

func _process(_delta):
	if holdable_object:
		var rot_x = 0
		if holdable_object.rotate_vertically:
			rot_x = get_viewport().get_camera_3d().rotation.x
		var rot = Vector3(rot_x, hand.rotation.y, hand.rotation.z)
		holdable_object.hold(hand.global_transform.origin, rot)

func has_item() -> bool:
	return holdable_object != null
