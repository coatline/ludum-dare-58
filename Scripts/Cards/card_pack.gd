extends HoldableObject
class_name CardPack

const CARD: PackedScene = preload("uid://dv7rsc3ce2imj")

@onready var back: MeshInstance3D = $CollisionShape3D/Back
@onready var box: MeshInstance3D = $CollisionShape3D/Box
@onready var face: MeshInstance3D = $CollisionShape3D/Face
var pack_type: CardPackType
var open_amount: float = 0


func _ready() -> void:
	if pack_type == null:
		set_type(ItemLibrary.card_packs.get_by_name("Common Pack"))
		#set_type(ItemLibrary.card_packs.get_random())

func set_type(type: CardPackType):
	pack_type = type
	display_name = pack_type.name

	var mat := Utils.get_new_material()
	mat.albedo_color = Color(0.05, 0.05, 0.05)
	box.set_surface_override_material(0, mat)
	
	Utils._apply_texture_to_face(face, type.texture)
	Utils._apply_texture_to_face(back, type.texture)

func use(direction: Vector3, delta: float, started: bool = false, finished: bool = false) -> void:
	if finished:
		open_amount = 0
		return
	
	open_amount += delta
	
	if open_amount >= pack_type.open_duration:
		open()

func open():
	var cards = pack_type.get_random_cards()

	for card in cards:
		var card_instance: CardObject = CARD.instantiate()
		get_parent().add_child(card_instance)
		card_instance.global_transform.origin = global_transform.origin
		card_instance.set_card_type(card)
	
	Utils.play_sound_at("OpenPack", global_position)
	queue_free()

func useable() -> bool: return true
func text_color() -> Color: return Utils.get_rarity_color(pack_type.rarity)
func use_text() -> String: return "Open " + Utils.color_string(display_name, Utils.get_rarity_color(pack_type.rarity))
