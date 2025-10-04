extends HoldableObject
class_name CardObject

@onready var mesh_instance_3d: MeshInstance3D = $CollisionShape3D/MeshInstance3D
var card_type: CardType 

func set_card_type(type: CardType):
	card_type = type
	var mat: Material = mesh_instance_3d.get_active_material(0)
	mat = mat.duplicate()
	mat.albedo_texture = card_type.texture
	mesh_instance_3d.set_surface_override_material(0, mat)
	display_name = type.display_name()
