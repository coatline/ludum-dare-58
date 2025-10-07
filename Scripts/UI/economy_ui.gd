extends UIOverlay
class_name EconomyUI

const UNIT_TEXT = preload("uid://b1n5t6e7ofj61")
const MARKET_PRICE_TEXT = preload("uid://c5qca7515lm7e")

@export var market_line_prefab: PackedScene
@export var horizontal_units_count: int = 10
@export var vertical_units_count: int = 10
@export var display_time: float = 360.0
@export var max_price: float = 100.0

@onready var graph_panel: Panel = $GraphPanel
@onready var vertical_units: Control = $VerticalUnits
@onready var horizontal_units: Control = $HorizontalUnits
@onready var time_scale: Label = $GraphPanel/TimeScale
@onready var market_texts: VBoxContainer = $MarketTexts
@onready var keybinds: KeybindsLabel = $"../../Keybinds"

var price_texts: Dictionary[CardType, RichTextLabel]
var market_uis: Dictionary[CardType, MarketUILine]
var visible_cards = []

func _ready() -> void:

	visible_cards = ItemLibrary.cards.unsorted_array.duplicate()

	for i in range(vertical_units_count + 1):
		var new_label: Label = UNIT_TEXT.instantiate()
		vertical_units.add_child(new_label)
		var percentage = i / float(vertical_units_count)
		new_label.global_position = graph_panel.global_position + Vector2(-new_label.size.x, (1 - percentage) * graph_panel.size.y - new_label.size.y / 4.0)
		new_label.text = "$" + "%d" % int(percentage * max_price)
		new_label.get_node("Line2D").add_point(Vector2(new_label.size.x, 0))
		new_label.get_node("Line2D").add_point(Vector2(graph_panel.size.x + new_label.size.x, 0))
	
	for card in visible_cards:
		var line_instance: MarketUILine = market_line_prefab.instantiate()
		graph_panel.add_child(line_instance)
		line_instance.set_card(card, self)
		line_instance.global_position = graph_panel.global_position
		market_uis[card] = line_instance
		
		var text_instance: RichTextLabel = MARKET_PRICE_TEXT.instantiate()
		market_texts.add_child(text_instance)
		text_instance.name = card.name
		price_texts[card] = text_instance
	
	Economy.economy_updated.connect(update_graph)
	set_display_time(display_time, "6h")
	disable()

func update_graph() -> void:
	for card in visible_cards:
		var after_text: String = ""
		var price_text: RichTextLabel = price_texts[card]
		var market: Market = Economy.card_to_market[card]
		var history: MarketHistory = market.get_market_history(display_time)
		
		if len(history.ticks) > 0:
			var delta = (market.current_price - history.ticks[0]) / history.ticks[0]

			after_text = "%.0f%%" % [delta * 100.0]
			if delta > 0:
				after_text = " [color=green]+" + after_text + "[/color]"
			elif delta < 0:
				after_text = " [color=red]" + after_text + "[/color]"
			else:
				after_text = " +0%"

		if market.current_price > 10.0:
			price_text.text = "[color=%s]%s[/color]: $%.0f %s" % [
				Utils.get_rarity_color(card.rarity).to_html(),
				card.name,
				market.current_price,
				after_text
			]
		else:
			price_text.text = "[color=%s]%s[/color]: $%.2f %s" % [
				Utils.get_rarity_color(card.rarity).to_html(),
				card.name,
				market.current_price,
				after_text
			]

func set_display_time(new_time: float, text: String, line_width: float = 5):
	time_scale.text = text
	display_time = new_time
	update_graph()
	
	for card in visible_cards:
		market_uis[card].set_line_width(line_width)

func enable():
	super.enable()

	Economy.economy_updated.connect(update_graph)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func disable():
	super.disable()
	
	if Economy.economy_updated.is_connected(update_graph):
		Economy.economy_updated.disconnect(update_graph)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func get_graph(market: Market) -> PackedVector2Array:
	var history: MarketHistory = market.get_market_history(display_time)
	return market.get_graph(display_time, history, graph_panel.size.x, graph_panel.size.y, max_price)
