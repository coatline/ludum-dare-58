extends ObjectHolder

@export var keybinds_label: KeybindsLabel

func pickup(obj):
	super.pickup(obj)
	keybinds_label.toggle_keybind("drop_item", true)
	keybinds_label.toggle_keybind("use_item", holdable_object.useable())

func object_left():
	super.object_left()
	keybinds_label.toggle_keybind("drop_item", false)
	keybinds_label.toggle_keybind("use_item", false)
