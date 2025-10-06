extends Interactable

@onready var light_bulb: ToggleableLight = $LightBulb

func interact(interactor: PlayerInteractor): light_bulb.toggle_light()

func can_interact(interactor: PlayerInteractor) -> bool: return true

func interact_text(interactor: PlayerInteractor) -> String: return "Toggle"
