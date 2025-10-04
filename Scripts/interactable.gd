extends Node3D
class_name Interactable

@export var display_name: String = "Interact"
signal hovered(started: bool)

func interact(interactor):
	print("Interacted with ", display_name)
