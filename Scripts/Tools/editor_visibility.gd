@tool
extends MeshInstance3D

func _ready():
	if Engine.is_editor_hint():
		visible = false
	else:
		visible = true
