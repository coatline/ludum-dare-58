extends Resource
class_name CardPackType

@export var cards : Array[CardType]
@export var open_time : float
@export var card_count : int
@export var rarity : Rarity
@export var price : float

func display_name() -> String: return resource_path.get_file().get_basename()

func get_random_cards() -> Array:
	var result := []
	if len(cards) == 0:
		return result
	
	var total_weight := 0.0
	for c in cards:
		total_weight += 1.0 / max(c.rarity.rarity_weight, 0.01)
	
	for i in card_count:
		var r := randf() * total_weight
		var cumulative := 0.0
		for c in cards:
			cumulative += 1.0 / max(c.rarity.rarity_weight, 0.01)
			if r <= cumulative:
				result.append(c)
				break
	
	return result
