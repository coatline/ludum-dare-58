extends Label


func _process(delta: float) -> void:
	text = TimeManager.get_time_string() + "\n" + TimeManager.get_day_string()
