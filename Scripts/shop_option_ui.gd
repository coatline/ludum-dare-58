extends Panel
class_name ShopOffer

signal expired

@export var background: Panel
@export var buy_button: Button
@export var item_image: TextureRect
@export var item_name: RichTextLabel

var item_type: ItemType
var price: float

func setup_offer(item_type_: ItemType, price_: float):
	item_type = item_type_
	item_image.texture = item_type.texture
	item_name.text = item_type.display_name()
	background.self_modulate = item_type_.get_color()
	MoneyManager.money_changed.connect(update_ui)
	set_price(price_)

func update_ui(delta_money: float = 0):
	if MoneyManager.money > price:
		buy_button.add_theme_color_override("font_color", Color(0, 1, 0))
		buy_button.disabled = false
	else:
		buy_button.add_theme_color_override("font_color", Color(1, 0, 0))
		buy_button.disabled = true

func _on_shop_button_pressed() -> void:
	if MoneyManager.money > price:
		MoneyManager.modify_funds(-price)
		Utils.play_sound_at("Buy", Vector3.ZERO)
		MoneyManager.bought_item.emit(item_type)

func set_price(new_price: float) -> void:
	price = new_price
	buy_button.text = "$%.2f" % [price]
	update_ui()

func _exit_tree() -> void:
	expired.emit()
