extends ItemType
class_name CardPackType

var card_spawn_weights: Dictionary = {}
var open_duration: float
var spawnable_card_ids := []
var spawn_weights := []

var card_count: int = 0
var rarity: String

func _init(data: Dictionary):
	super._init(data)

	card_count = int(data.get("Card Count", 0))
	spawnable_card_ids = parse_list(str(data.get("Cards", "")))
	spawn_weights = parse_list(str(data.get("Spawn Weights", "")))
	card_spawn_weights = get_card_weight_dict(spawnable_card_ids, spawn_weights)
	rarity = String(data.get("Rarity", "Unknown"))
	open_duration = float(data.get("Open Duration", 0))
	# debug_print()

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

func get_card_weight_dict(cards_: Array, weights: Array) -> Dictionary:
	var dict := {}
	for i in range(min(cards_.size(), weights.size())):
		dict[spawnable_card_ids[i]] = weights[i]
	return dict

func get_random_cards() -> Array[CardType]:
	var selected: Array[CardType] = []
	
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
				var card = ItemLibrary.cards.get_by_id(card_id)
				if card:
					selected.append(card)
				break
	
	return selected

func get_texture_folder() -> String: return "Card Packs"

func debug_print() -> void:
	print("--- CardPackType Debug ---")
	print("Card Count: ", card_count)
	print("Cards: ", spawnable_card_ids)
	print("Spawn Weights: ", spawn_weights)
	print("Card Spawn Weights Dict: ", card_spawn_weights)
	print("--------------------------")
