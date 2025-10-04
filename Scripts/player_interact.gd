extends RayCast3D

@export var interact_label: Label
@export var interact_distance: float = 3.0
@export var object_holder : ObjectHolder

var hovered_object: Interactable = null

func _physics_process(delta):
	target_position = -transform.basis.z * interact_distance
	force_raycast_update()

	if is_colliding():
		var collider = get_collider()
		if collider is Interactable:
			if hovered_object != collider:
				if hovered_object:
					hovered_object.emit_signal("hovered", false)
				hovered_object = collider
				hovered_object.emit_signal("hovered", true)
			
			interact_label.text = collider.display_name + " - E"
			if Input.is_action_just_pressed("interact"):
				collider.interact(self)
		else:
			_clear_hover()
	else:
		_clear_hover()

func _clear_hover():
	if hovered_object:
		hovered_object.emit_signal("hovered", false)
		hovered_object = null
	interact_label.text = ""
