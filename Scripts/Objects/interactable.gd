extends Node3D
class_name Interactable

signal hovered(started: bool)

func interact(interactor: PlayerInteractor): print("Interacted with ", name)

func can_interact(interactor: PlayerInteractor) -> bool: return false

func interact_text(interactor: PlayerInteractor) -> String: return "Interact"
