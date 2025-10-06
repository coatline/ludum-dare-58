extends Resource
class_name ItemType

@export var price : float
@export var color : Color
@export var texture: Texture2D
@export var scene: PackedScene

func get_color() -> Color: return color
func display_name() -> String: return resource_path.get_file().get_basename()