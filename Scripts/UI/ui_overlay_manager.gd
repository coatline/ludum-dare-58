extends Control
class_name UIOverlayManager

@onready var catalog_ui: CatalogUI = $CatalogUI
@onready var market_ui: MarketUI = $MarketUI
@onready var shop_ui: ShopUI = $ShopUI

var current_overlay: UIOverlay

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_stocks"):
		toggle(market_ui)
	
	if Input.is_action_just_pressed("open_shop"):
		toggle(shop_ui)
	
	if Input.is_action_just_pressed("open_catalog"):
		toggle(catalog_ui)
	
	if Input.is_action_just_pressed("ui_cancel"):
		if current_overlay != null:
			deactivate_current()
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			# get_tree().paused = not get_tree().paused

func toggle(overlay: UIOverlay) -> void:
	if current_overlay == overlay:
		deactivate_current()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		activate(overlay)

func activate(overlay: UIOverlay) -> void:
	if current_overlay != null and current_overlay != overlay:
		deactivate_current()
	
	current_overlay = overlay
	current_overlay.enable()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func deactivate_current() -> void:
	if current_overlay != null:
		current_overlay.disable()
		current_overlay = null

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and is_active() == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_stocks_pressed() -> void:
	toggle(market_ui)

func _on_shop_pressed() -> void:
	toggle(shop_ui)

func _on_catalog_pressed() -> void:
	toggle(catalog_ui)

func is_active() -> bool: return current_overlay != null
