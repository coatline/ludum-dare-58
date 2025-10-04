extends Resource
class_name CardPackType

@export var cards : Array[CardType]
@export var open_time : float
@export var card_count : int
@export var rarity : float
@export var price : float

func display_name() -> String: return resource_path.get_file().get_basename()
