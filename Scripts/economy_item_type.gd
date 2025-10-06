extends ItemType
class_name EconomyItemType

@export var rarity : Rarity

func get_color() -> Color: return rarity.color * 0.5
func display_name() -> String: return resource_path.get_file().get_basename()
