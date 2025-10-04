extends HoldableObject

func use(direction: Vector3, started: bool = false, finished: bool = false) -> void:
	queue_free()

func useable() -> bool: return true
