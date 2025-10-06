extends Panel
class_name ShopOffer

signal expired

@onready var item_image: TextureRect = $ItemImage
@onready var expiration_text: Label = $ProgressBar/ExpirationText
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var item_name: RichTextLabel = $ItemName
@onready var shop_button: Button = $ShopButton

var offer_duration: float = 0
var time_remaining: float = 0
var item_type: ItemType
var price: float

func setup_offer(item_type_: ItemType, price_: float, duration: float):
	offer_duration = duration
	item_type = item_type_
	price = price_
	time_remaining = duration
	item_name.text = item_type.display_name()
	item_image.texture = item_type.texture
	shop_button.text = "$%.2f" % [price]
	MoneyManager.money_changed.connect(update_ui)
	update_ui()

func update_ui(delta_money: float = 0):
	if MoneyManager.money > price:
		shop_button.add_theme_color_override("font_color", Color(0, 1, 0))
		shop_button.disabled = false
	else:
		shop_button.add_theme_color_override("font_color", Color(1, 0, 0))
		shop_button.disabled = true

func _on_shop_button_pressed() -> void:
	if MoneyManager.money > price:
		MoneyManager.modify_funds(-price)
		Utils.play_sound_at("Buy", Vector3.ZERO)
		MoneyManager.bought_item.emit(item_type)
		queue_free()

func _process(delta: float) -> void:
	time_remaining -= delta * TimeManager.time_scale
	progress_bar.value = (time_remaining / offer_duration)
	
	expiration_text.text = "Expires: " + TimeManager.get_duration_string(time_remaining / TimeManager.time_scale)
	
	if time_remaining <= 0:
		queue_free()

func _exit_tree() -> void:
	expired.emit()
