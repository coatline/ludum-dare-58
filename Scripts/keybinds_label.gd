extends Label
class_name KeybindsLabel

var keys_dict = {"drop_item": false, "use_item": false, "interact" : false}
var keys_order = ["interact", "drop_item", "use_item"]

var control_scheme = "keyboard"

var display_names = {
	"keyboard": {"drop_item": "Drop - Q", "use_item": "Use - LMB", "interact": "Interact - E"},
	"gamepad": {"drop_item": "Drop - X", "use_item": "Use - RT", "interact": "Interact - A"}
}

func _init() -> void:
	keys_order.reverse()

func toggle_keybind(key: String, enabled: bool) -> void:
	if key in keys_dict:
		keys_dict[key] = enabled
	update_text()

func update_text():
	var key_index = 0
	text = ""
	
	for key in keys_order:
		if keys_dict[key]:
			if key_index > 0:
				text += "\n"
			text += display_names[control_scheme].get(key, key)
			key_index += 1
