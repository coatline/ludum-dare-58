extends Node
class_name InputHelper

# Detect whether the player is using a gamepad or keyboard/mouse
func is_using_gamepad() -> bool:
	for device_id in Input.get_connected_joypads():
		if Input.is_joy_known(device_id):
			return true
	return false

# Get a display-friendly keybind string for an input action
func get_keybind_display(action_name: String) -> String:
	var use_gamepad = is_using_gamepad()
	var events = InputMap.action_get_events(action_name)
	
	if events.is_empty():
		return "Unbound"
	
	for event in events:
		if use_gamepad and event is InputEventJoypadButton:
			return _get_joypad_button_name(event.button_index)
		elif not use_gamepad and event is InputEventKey:
			return OS.get_keycode_string(event.physical_keycode)
		elif not use_gamepad and event is InputEventMouseButton:
			return _get_mouse_button_name(event.button_index)
	
	return "Unknown"

# Converts a joypad button index to readable name
func _get_joypad_button_name(button_index: int) -> String:
	match button_index:
		JOY_BUTTON_A: return "A"
		JOY_BUTTON_B: return "B"
		JOY_BUTTON_X: return "X"
		JOY_BUTTON_Y: return "Y"
		JOY_BUTTON_LEFT_SHOULDER: return "LB"
		JOY_BUTTON_RIGHT_SHOULDER: return "RB"
		JOY_BUTTON_BACK: return "Back"
		JOY_BUTTON_START: return "Start"
		JOY_BUTTON_DPAD_UP: return "D-Pad Up"
		JOY_BUTTON_DPAD_DOWN: return "D-Pad Down"
		JOY_BUTTON_DPAD_LEFT: return "D-Pad Left"
		JOY_BUTTON_DPAD_RIGHT: return "D-Pad Right"
		_: return "Button " + str(button_index)

# Converts mouse buttons to readable names
func _get_mouse_button_name(button_index: int) -> String:
	match button_index:
		MOUSE_BUTTON_LEFT: return "LMB"
		MOUSE_BUTTON_RIGHT: return "RMB"
		MOUSE_BUTTON_MIDDLE: return "MMB"
		MOUSE_BUTTON_WHEEL_UP: return "Wheel Up"
		MOUSE_BUTTON_WHEEL_DOWN: return "Wheel Down"
		_: return "Mouse " + str(button_index)
