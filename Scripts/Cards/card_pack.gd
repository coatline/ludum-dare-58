extends HoldableObject

const CARD: PackedScene = preload("uid://dv7rsc3ce2imj")

@onready var back: MeshInstance3D = $CollisionShape3D/Back
@onready var box: MeshInstance3D = $CollisionShape3D/Box
@onready var face: MeshInstance3D = $CollisionShape3D/Face
@export var starting_pack_type: CardPackType = null
var pack_type: CardPackType
var open_amount: float = 0

func set_type(type: CardPackType):
	pack_type = type
	display_name = pack_type.display_name()

	var mat := Utils.get_new_material()
	mat.albedo_color = Color(0.05, 0.05, 0.05)
	box.set_surface_override_material(0, mat)
	
	Utils._apply_texture_to_face(face, type.front_texture)
	Utils._apply_texture_to_face(back, type.front_texture)

func _ready() -> void:
	if pack_type == null:
		if starting_pack_type:
			set_type(starting_pack_type)
		else:
			set_type(ResourceManager.get_random_resource(CardPackType))

func use(direction: Vector3, delta: float, started: bool = false, finished: bool = false) -> void:
	if finished:
		open_amount = 0
		return
	
	open_amount += delta
	
	if open_amount >= pack_type.open_time:
		open()

func open():
	var cards = pack_type.get_random_cards()

	for card in cards:
		var card_instance: CardObject = CARD.instantiate()
		get_parent().add_child(card_instance)
		card_instance.global_transform.origin = global_transform.origin
		card_instance.set_card_type(card)
	
	queue_free()

func useable() -> bool: return true
func text_color() -> Color: return pack_type.rarity.color
func use_text() -> String: return "Open " + Utils.color_string_with_rarity(display_name, pack_type.rarity)
