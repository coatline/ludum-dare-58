extends Node3D
class_name Interactable

@export var display_name: String = "Interact"

func interact(interactor):
	print("Interacted with ", display_name)

signal hovered(started: bool)
