extends RayCast3D
class_name PlayerInteractor

@export var interact_distance: float = 3.0
@export var object_holder : ObjectHolder
@export var keybinds_label: KeybindsLabel

var hovered_object: Interactable = null

func _physics_process(delta):
	target_position = -transform.basis.z * interact_distance
	force_raycast_update()
	
	if is_colliding():
		var collider = get_collider()
		var interactable: Interactable = null
	
		while collider:
			interactable = collider as Interactable
			if interactable:
				break
			collider = collider.get_parent()
		
		if interactable:
			if interactable.can_interact(self):
				if hovered_object != interactable:
					if hovered_object:
						hovered_object.hovered.emit(false)
					hovered_object = interactable
					hovered_object.hovered.emit(true)
				
				if Input.is_action_just_pressed("interact"):
					keybinds_label.hide_keybind("interact")
					collider.interact(self)
				else:
					keybinds_label.show_keybind(interactable.interact_text(self), "interact")
				
				return
	
	_clear_hover()

func _clear_hover():
	if hovered_object:
		hovered_object.hovered.emit(false)
		hovered_object = null
	
	keybinds_label.hide_keybind("interact")
