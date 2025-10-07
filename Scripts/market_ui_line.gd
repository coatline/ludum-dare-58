extends Line2D
class_name MarketUILine

var economy_ui: EconomyUI
var market: Market
var card: CardType

func set_card(card_: CardType, economy_ui_: EconomyUI):
	economy_ui = economy_ui_
	card = card_
	market = Economy.card_to_market[card]
	default_color = Utils.get_rarity_color(card.rarity)
	name = card.name

func set_line_width(width_: float):
	width = width_

func _process(delta: float) -> void:
	if visible == false:
		return
	
	points = economy_ui.get_graph(market)
