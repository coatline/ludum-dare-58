extends CanvasLayer

@export var animation_player: AnimationPlayer
@export var fade_out_anim_name: String = "fade_out"

var _next_scene_path: String = ""

func switch_scene(new_scene_path: String) -> void:
	_next_scene_path = new_scene_path
	
	if not animation_player.has_animation(fade_out_anim_name):
		push_error("Animation not found: " + fade_out_anim_name)
		get_tree().change_scene(_next_scene_path)
		return
	
	animation_player.play(fade_out_anim_name)
	animation_player.connect("animation_finished", _on_animation_finished, CONNECT_ONE_SHOT)

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == fade_out_anim_name:
		get_tree().change_scene(_next_scene_path)
