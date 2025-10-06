extends Resource
class_name ItemType

@export var rarity : Rarity
@export var texture: Texture2D
@export var scene: PackedScene

func display_name() -> String: return resource_path.get_file().get_basename()
