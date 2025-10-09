extends ItemType
class_name CardType

enum CardGrade { COMMON, RARE, EPIC, LEGENDARY }

var demand_scale: float
var demand_randomness: float
var demand_recovery_strength: float
var demand_trend_inertia: float
var rarity: String

func _init(data: Dictionary):
	super._init(data)
	demand_scale = float(data.get("Demand Scale", 0))
	demand_randomness = float(data.get("Demand Randomness", 0))
	demand_recovery_strength = float(data.get("Demand Recovery Strength", 0))
	demand_trend_inertia = float(data.get("Demand Trend Inertia", 0))
	rarity = String(data.get("Rarity", "Unknown"))
	debug_print()

func debug_print():
	print("----- Card Info -----")
	print("Name: ", name)
	print("Texture: ", texture)
	print("Demand Scale: ", demand_scale)
	print("Demand Randomness: ", demand_randomness)
	print("Demand Recovery Strength: ", demand_recovery_strength)
	print("Demand Trend Inertia: ", demand_trend_inertia)
	print("Price: ", price)
	print("Description: ", description)
	print("--------------------")

func get_texture_folder() -> String: return "Cards"

func get_color() -> Color:
	match rarity:
		"Common":
			return Color(1, 1, 1) # White
		"Uncommon":
			return Color(0, 1, 0) # Green
		"Rare":
			return Color(0, 0, 1) # Blue
		"Epic":
			return Color(0.6, 0, 0.8) # Purple
		"Legendary":
			return Color(1, 0.5, 0) # Orange
		_:
			return Color(0, 0, 0) # Default to black
