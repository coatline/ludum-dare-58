class_name ItemType

var name: String
var price: float
var texture: Texture2D
var scene: PackedScene
var description: String

func _init(data: Dictionary):
	name = data.get("Name", "Unknown")
	price = float(data.get("Price", 0))
	description = data.get("Description", "")
	scene = load("res://Scenes/Items/" + data.get("Scene") + ".tscn")
	texture = load(get_texture_path() + data.get("Sprite", "Default_Card") + ".png")

func get_texture_path() -> String: return "res://Graphics/Items/"
