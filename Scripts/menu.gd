extends Control

@export var playSound: AudioStream


func _on_play_pressed():
	SoundManager.PlaySound(playSound)
	print("Playing")
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _on_quit_pressed():
	get_tree().quit()
