extends ShopOffer
class_name MarketplaceOptionUI

@export var progress_bar: ProgressBar
@export var expiration_text: Label
var offer_duration: float = 0
var time_remaining: float = 0


func set_duration(duration: float):
	offer_duration = duration
	time_remaining = duration

func _process(delta: float) -> void:
	time_remaining -= delta * TimeManager.time_scale
	progress_bar.value = (time_remaining / offer_duration)
	
	expiration_text.text = "" + TimeManager.get_duration_string(time_remaining / TimeManager.time_scale)
	
	if time_remaining <= 0:
		queue_free()

func _on_shop_button_pressed() -> void:
	super._on_shop_button_pressed()
	queue_free()
