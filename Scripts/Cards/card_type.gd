extends Resource
class_name CardType

@export var rarity : Rarity
@export var texture: Texture2D

func display_name() -> String: return resource_path.get_file().get_basename()