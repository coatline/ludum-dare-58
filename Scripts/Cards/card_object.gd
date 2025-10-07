extends HoldableObject
class_name CardObject

@onready var face: MeshInstance3D = $CollisionShape3D/Face
@onready var face_2: MeshInstance3D = $CollisionShape3D/Face2
var card_type: CardType 

func set_card_type(type: CardType):
	card_type = type
	display_name = type.name + " (%s)" % type.rarity
	
	Utils._apply_texture_to_face(face, type.texture)
	Utils._apply_texture_to_face(face_2, type.texture)

func text_color() -> Color: return Utils.get_rarity_color(card_type.rarity)
