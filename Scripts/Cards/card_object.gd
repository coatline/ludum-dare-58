extends HoldableObject
class_name CardObject

@onready var mesh_instance_3d: MeshInstance3D = $CollisionShape3D/MeshInstance3D
@onready var face: MeshInstance3D = $CollisionShape3D/Face
@onready var face_2: MeshInstance3D = $CollisionShape3D/Face2
var card_type: CardType 

func set_card_type(type: CardType):
	card_type = type
	display_name = type.display_name()
	
	_apply_texture_to_face(face, type.texture)
	_apply_texture_to_face(face_2, type.texture)

func _apply_texture_to_face(face_mesh: MeshInstance3D, tex: Texture2D):
	var mat := StandardMaterial3D.new()
	mat.albedo_texture = tex
	mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST  # keeps pixel-art sharp
	mat.uv1_scale = Vector3(1, 1, 1)  # ensures full texture is shown
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED     # optional: makes it 2D-looking
	face_mesh.set_surface_override_material(0, mat)


func text_color() -> Color: return card_type.rarity.color
