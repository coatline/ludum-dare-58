extends ItemType
class_name CardType

enum CardGrade { COMMON, RARE, EPIC, LEGENDARY }

var starting_demand: float
var demand_drift: float
var demand_recovery: float
var demand_trend_inertia: float

func _init(data: Dictionary):
	super._init(data)
	starting_demand = float(data.get("Starting Demand", 0))
	demand_drift = float(data.get("Demand Drift", 0))
	demand_recovery = float(data.get("Demand Recovery Strength", 0))
	demand_trend_inertia = float(data.get("Demand Trend Inertia", 0))
	debug_print()

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

func get_texture_path() -> String: return "res://Graphics/Cards"
