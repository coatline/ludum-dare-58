extends Button

@export var marketUI: MarketUI
@export var display_time: float = 60
@export var line_width: float = 5

func _on_pressed() -> void:
	marketUI.set_display_time(display_time, text, line_width)
