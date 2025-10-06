extends StaticBody3D
class_name ToggleableLight

@onready var omni_light_3d: OmniLight3D = $OmniLight3D
@onready var mesh_instance_3d: MeshInstance3D = $CollisionShape3D/MeshInstance3D

var original_color: Color
var material: StandardMaterial3D

func _ready():
	material = mesh_instance_3d.get_active_material(0) as StandardMaterial3D
	if material:
		original_color = material.albedo_color
	
	omni_light_3d.visible = not omni_light_3d.visible
	toggle_light()

func toggle_light():
	omni_light_3d.visible = not omni_light_3d.visible
	if material:
		if omni_light_3d.visible:
			material.albedo_color = Color(original_color.r, original_color.g, original_color.b, 1.0) * 1.25
		else:
			material.albedo_color = original_color * 0.2
