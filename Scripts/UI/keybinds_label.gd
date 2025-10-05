extends RichTextLabel
class_name KeybindsLabel

var keys = {}

func show_keybind(message: String, input_action: String) -> void:
	var keybind = KeybindHelper.get_keybind_display(input_action)
	keys[input_action] = keybind + ": " + message
	update_text()

func hide_keybind(input_action: String) -> void:
	keys.erase(input_action)
	update_text()

func update_text():
	var key_index = 0
	text = ""
	
	for key in keys:
		if key_index > 0:
			text += "\n"
		text += keys[key]
		key_index += 1
