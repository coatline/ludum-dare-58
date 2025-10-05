extends ObjectHolder

@export var progress_bar : ProgressBar
@export var keybinds_label: KeybindsLabel
@export var object_holder : ObjectHolder
@export var max_throw_force: float = 10.0

var throw_percentage: float = 0.0

func pickup(obj):
	super.pickup(obj)
	keybinds_label.show_keybind(Utils.get_verb_item_string("Throw ", holdable_object), "drop_item")
	if holdable_object.useable():
		keybinds_label.show_keybind(holdable_object.use_text(), "use_item")

func object_gone():
	keybinds_label.hide_keybind("drop_item")
	keybinds_label.hide_keybind("use_item")
	super.object_gone()

func _process(_delta):
	super._process(_delta)

	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	
	if Input.is_action_pressed("use_item"):
		var started = Input.is_action_just_pressed("use_item")
		if started:
			finish_dropping()
		
		object_holder.try_use(_delta, started, false)

	elif Input.is_action_just_released("use_item"):
		object_holder.try_use(_delta, false, true)

	elif Input.is_action_pressed("drop_item"):
		throw_percentage += _delta
		progress_bar.visible = throw_percentage > 0.2
		progress_bar.value = (throw_percentage - 0.2) / 0.8 

	elif Input.is_action_just_released("drop_item"):
		object_holder.try_drop(throw_percentage * max_throw_force)
		finish_dropping()

func finish_dropping():
	throw_percentage = 0
	progress_bar.value = 0
	progress_bar.visible = false
