extends ObjectHolder

@export var drop_label: Label

func pickup(obj):
	super.pickup(obj)
	drop_label.visible = true

func object_left():
	super.object_left()
	drop_label.visible = false
