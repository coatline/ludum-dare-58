extends ObjectHolder

@export var keybinds_label: KeybindsLabel

func pickup(obj):
	super.pickup(obj)
	keybinds_label.show_keybind("Drop " + holdable_object.display_name, "drop_item")
	if holdable_object.useable():
		keybinds_label.show_keybind(holdable_object.use_text(), "use_item")

func object_gone():
	keybinds_label.hide_keybind("drop_item")
	keybinds_label.hide_keybind("use_item")
	super.object_gone()
