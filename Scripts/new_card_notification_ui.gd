extends Panel
class_name NewCardNotificationUI

@onready var card_name: RichTextLabel = $CardName
@onready var card_image: TextureRect = $CardImage

var lifetime = 0.0
var slide_time = 0.35
var pause_time = 5

func set_card(card: CardType):
	card_name.text = card.display_name()
	card_image.texture = card.texture

func _process(delta: float) -> void:
	lifetime += delta
	if lifetime < slide_time:
		position.y = lerp(float(-size.y), 0.0, lifetime / slide_time)
	elif lifetime < slide_time + pause_time:
		position.y = 0.0
	else:
		var t = (lifetime - slide_time - pause_time) / slide_time
		position.y = lerp(0.0, float(-size.y), t)
		if t >= 1.0:
			queue_free()
