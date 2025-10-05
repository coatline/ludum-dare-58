extends Panel
class_name MarketUI

const UNIT_TEXT = preload("uid://b1n5t6e7ofj61")
const MARKET_PRICE_TEXT = preload("uid://c5qca7515lm7e")

@export var market_line_prefab: PackedScene
@export var horizontal_units_count: int = 10
@export var vertical_units_count: int = 10
@export var display_time: float = 60.0
@export var max_price: float = 100.0

@onready var graph_panel: Panel = $GraphPanel
@onready var vertical_units: Control = $VerticalUnits
@onready var horizontal_units: Control = $HorizontalUnits
@onready var time_scale: Label = $GraphPanel/TimeScale
@onready var market_texts: VBoxContainer = $MarketTexts
@onready var keybinds: KeybindsLabel = $"../Keybinds"

var lines = {}
var price_texts = {}
var active = false

func _ready() -> void:
	for i in range(vertical_units_count + 1):
		var new_label: Label = UNIT_TEXT.instantiate()
		vertical_units.add_child(new_label)
		var percentage = i / float(vertical_units_count)
		new_label.global_position = graph_panel.global_position + Vector2(-new_label.size.x, (1 - percentage) * graph_panel.size.y - new_label.size.y / 4.0)
		new_label.text = "$" + "%d" % int(percentage * max_price)
		new_label.get_node("Line2D").add_point(Vector2(new_label.size.x, 0))
		new_label.get_node("Line2D").add_point(Vector2(graph_panel.size.x + new_label.size.x, 0))
	
	for rarity in Economy.markets:
		var line_instance: Line2D = market_line_prefab.instantiate()
		graph_panel.add_child(line_instance)
		line_instance.global_position = graph_panel.global_position
		line_instance.default_color = rarity.color
		line_instance.name = rarity.display_name
		lines[rarity] = line_instance
		
		var text_instance: Label = MARKET_PRICE_TEXT.instantiate()
		market_texts.add_child(text_instance)
		text_instance.modulate = rarity.color
		text_instance.name = rarity.display_name
		price_texts[rarity] = text_instance
	
	Economy.economy_updated.connect(update_graph)
	set_display_time(display_time, "1H")
	disable()

func update_graph() -> void:
	for rarity in Economy.markets:
		var line: Line2D = lines[rarity]
		var market: Market = Economy.markets[rarity]
		line.points = market.get_graph(display_time, graph_panel.size.x, graph_panel.size.y, max_price)
		
		var price_text: Label = price_texts[rarity]
		price_text.text = "%s: $%.2f" % [rarity.display_name, market.current_price]

func set_display_time(new_time: float, text: String, line_width: float = 5):
	time_scale.text = text
	display_time = new_time
	update_graph()
	
	for line in lines:
		lines[line].width = line_width

func enable():
	active = true
	visible = true
	Economy.economy_updated.connect(update_graph)
	keybinds.show_keybind("Close Market", "open_stocks")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func disable():
	active = false
	visible = false
	if Economy.economy_updated.is_connected(update_graph):
		Economy.economy_updated.disconnect(update_graph)
	keybinds.show_keybind("View Market", "open_stocks")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
