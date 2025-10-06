extends UIOverlay
class_name ShopUI

const SHOP_OPTION = preload("uid://b838i3tsnqtqb")
const MAX_OFFERS = 6

@onready var shop_text: RichTextLabel = $ShopText
@export var marketplace: Marketplace
@export var retail: Retail

var current: Control

func _ready() -> void:
	change_to(retail)

func _on_marketplace_tab_pressed() -> void:
	change_to(marketplace)

func _on_retail_tab_pressed() -> void:
	change_to(retail)

func change_to(new_tab):
	if current != null:
		current.visible = false
	current = new_tab
	current.visible = true
	shop_text.text = current.name
