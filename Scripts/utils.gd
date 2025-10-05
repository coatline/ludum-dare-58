extends Node

func get_item_string(holdable_object: HoldableObject) -> String:
	return "[color=%s]%s[/color]" % [holdable_object.text_color().to_html(), holdable_object.display_name]

func color_string_with_rarity(message: String, rarity: Rarity):
	return "[color=%s]%s[/color]" % [rarity.color.to_html(), message]

func get_verb_item_string(message: String, holdable_object: HoldableObject) -> String:
	return "%s[color=%s]%s[/color]" % [message, holdable_object.text_color().to_html(), holdable_object.display_name]
