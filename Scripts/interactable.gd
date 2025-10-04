extends Node3D
class_name Interactable

@export var display_name: String = "Interact"
signal hovered(started: bool)

func interact(interactor: PlayerInteractor):
	print("Interacted with ", display_name)

func can_interact(interactor: PlayerInteractor) -> bool:
	return false
