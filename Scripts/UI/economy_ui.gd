extends UIOverlay
class_name MarketUI

const UNIT_TEXT = preload("uid://b1n5t6e7ofj61")
const MARKET_PRICE_TEXT = preload("uid://c5qca7515lm7e")

@export var market_line_prefab: PackedScene
@export var horizontal_units_count: int = 10
@export var vertical_units_count: int = 10
@export var display_time: float = 60.0
@export var max_price: float = 100.0
@export var rarities: Array[Rarity]

@onready var graph_panel: Panel = $GraphPanel
@onready var vertical_units: Control = $VerticalUnits
@onready var horizontal_units: Control = $HorizontalUnits
@onready var time_scale: Label = $GraphPanel/TimeScale
@onready var market_texts: VBoxContainer = $MarketTexts
@onready var keybinds: KeybindsLabel = $"../../Keybinds"

var lines = {}
var price_texts = {}

func _ready() -> void:
	for i in range(vertical_units_count + 1):
		var new_label: Label = UNIT_TEXT.instantiate()
		vertical_units.add_child(new_label)
		var percentage = i / float(vertical_units_count)
		new_label.global_position = graph_panel.global_position + Vector2(-new_label.size.x, (1 - percentage) * graph_panel.size.y - new_label.size.y / 4.0)
		new_label.text = "$" + "%d" % int(percentage * max_price)
		new_label.get_node("Line2D").add_point(Vector2(new_label.size.x, 0))
		new_label.get_node("Line2D").add_point(Vector2(graph_panel.size.x + new_label.size.x, 0))
	
	for rarity in rarities:
		var line_instance: Line2D = market_line_prefab.instantiate()
		graph_panel.add_child(line_instance)
		line_instance.global_position = graph_panel.global_position
		line_instance.default_color = rarity.color
		line_instance.name = rarity.display_name
		lines[rarity] = line_instance
		
		var text_instance: RichTextLabel = MARKET_PRICE_TEXT.instantiate()
		market_texts.add_child(text_instance)
		text_instance.name = rarity.display_name
		price_texts[rarity] = text_instance
	
	Economy.economy_updated.connect(update_graph)
	set_display_time(display_time, "1H")
	disable()

func update_graph() -> void:
	for rarity in rarities:
		var line: Line2D = lines[rarity]
		var market: Market = Economy.markets[rarity]
		var history: MarketHistory = market.get_market_history(display_time)
		line.points = market.get_graph(display_time, history, graph_panel.size.x, graph_panel.size.y, max_price)

		var after_text: String = ""
		var price_text: RichTextLabel = price_texts[rarity]

		if len(history.ticks) > 0:
			var delta = (market.current_price - history.ticks[0]) / history.ticks[0]

			after_text = "%.0f%%" % [delta * 100.0]
			if delta > 0:
				after_text = " [color=green]+" + after_text
			elif delta < 0:
				after_text = " [color=red]" + after_text
		
		if market.current_price > 10.0:
			price_text.text = "[color=%s]%s: $%.0f [/color]%s[/color]" % [
				rarity.color.to_html(false),
				rarity.display_name,
				market.current_price,
				after_text
			]
		else:
			price_text.text = "[color=%s]%s: $%.2f [/color]%s[/color]" % [
				rarity.color.to_html(false),
				rarity.display_name,
				market.current_price,
				after_text
			]

func set_display_time(new_time: float, text: String, line_width: float = 5):
	time_scale.text = text
	display_time = new_time
	update_graph()
	
	for line in lines:
		lines[line].width = line_width

func enable():
	super.enable()

	Economy.economy_updated.connect(update_graph)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func disable():
	super.disable()
	
	if Economy.economy_updated.is_connected(update_graph):
		Economy.economy_updated.disconnect(update_graph)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
