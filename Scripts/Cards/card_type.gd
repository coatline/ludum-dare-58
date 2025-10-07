extends ItemType
class_name CardType

enum CardGrade { COMMON, RARE, EPIC, LEGENDARY }

var demand_trend_inertia: float
var demand_recovery: float
var starting_demand: float
var demand_drift: float
var rarity: String

func _init(data: Dictionary):
	super._init(data)
	starting_demand = float(data.get("Starting Demand", 0))
	demand_drift = float(data.get("Demand Drift", 0))
	demand_recovery = float(data.get("Demand Recovery Strength", 0))
	demand_trend_inertia = float(data.get("Demand Trend Inertia", 0))
	rarity = String(data.get("Rarity", "Unknown"))
	# debug_print()

func debug_print():
	print("----- Card Info -----")
	print("Name: ", name)
	print("Texture: ", texture)
	print("Starting Demand: ", starting_demand)
	print("Demand Drift: ", demand_drift)
	print("Demand Recovery: ", demand_recovery)
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
