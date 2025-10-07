class_name ItemType

var id: int
var name: String
var price: float
var texture: Texture2D
var scene: PackedScene
var description: String

func _init(data: Dictionary):
	id = int(data.get("ID", -1))
	name = data.get("Name", "Unknown")
	print("Loading: %s" % name)
	price = float(data.get("Price", 0))
	description = data.get("Description", "")
	var scene_name = data.get("Scene")
	if scene_name: 
		scene = load("res://Scenes/Items/" + data.get("Scene") + ".tscn")
	var texture_name = data.get("Texture")
	if texture_name:
		texture = load("res://Graphics/" + get_texture_folder() + "/" + texture_name + ".png")

func get_texture_folder() -> String: return "Items"
