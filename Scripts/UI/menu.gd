extends Control

func _on_play_pressed():
	Utils.play_sound_at("Buy", null, 1.0, false)
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _on_quit_pressed():
	Utils.play_sound_at("Sell", null, 1.0, false)
	get_tree().quit()
