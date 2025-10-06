extends ItemType
class_name ItemPack

var card_spawn_weights: Dictionary = {}
var spawn_weights: Array[float] = []
var cards: Array[int] = []
var card_count: int = 0

func _init(data: Dictionary):
	super._init(data)

	card_count = int(data.get("Card Count", 0))
	cards = parse_list(str(data.get("Cards", "")))
	spawn_weights = parse_list(str(data.get("Spawn Weights", "")))
	card_spawn_weights = get_card_weight_dict(cards, spawn_weights)

func parse_list(raw: String) -> Array:
	if raw == "":
		return []
	var arr: Array = []
	for s in raw.split(","):
		var val = s.strip_edges()
		if val.is_valid_int():
			arr.append(int(val))
		elif val.is_valid_float():
			arr.append(float(val))
	return arr

func get_card_weight_dict(cards: Array, weights: Array) -> Dictionary:
	var dict := {}
	for i in range(min(cards.size(), weights.size())):
		dict[cards[i]] = weights[i]
	return dict

func get_random_cards(all_cards: Array) -> Array:
	var selected: Array = []
	if card_spawn_weights.is_empty():
		return selected
	
	var total_weight: float = 0.0
	for weight in card_spawn_weights.values():
		total_weight += weight
	
	for i in range(card_count):
		var pick = randf() * total_weight
		var running_sum = 0.0
		
		for card_id in card_spawn_weights.keys():
			running_sum += card_spawn_weights[card_id]
			if pick <= running_sum:
				if card_id < all_cards.size():
					selected.append(all_cards[card_id])
				break
	
	return selected
