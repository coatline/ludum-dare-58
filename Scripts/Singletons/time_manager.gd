extends Node

signal minute_changed(minute: int)
signal hour_changed(hour: int)
signal day_changed(day: int)

var time_scale: float = 7.0
var minutes_in_day := 24 * 60

var current_time: float = 480.0
var total_time: float = 0.0
var current_day: int = 1

func _process(delta: float) -> void:
	update_time(delta)

func update_time(delta: float) -> void:
	var prev_hour = get_hour_24(current_time)
	var prev_minute = get_minute(current_time)

	var scaled_delta = delta * time_scale
	total_time += scaled_delta
	current_time += scaled_delta

	if current_time >= minutes_in_day:
		current_time -= minutes_in_day
		current_day += 1
		day_changed.emit(current_day)

	var new_hour = get_hour_24(current_time)
	if new_hour != prev_hour:
		hour_changed.emit(new_hour)
	
	var new_minute = get_minute(current_time)
	if new_minute != prev_minute:
		minute_changed.emit(new_minute)

func get_hour_24(time: float) -> int:
	return int(time / 60.0) % 24

func get_minute(time: float) -> int:
	return (int(time * 60) % 3600) / 60

func get_time_string(time: float) -> String:
	var hour_24 = get_hour_24(time)
	var minute = get_minute(time)

	var period = "AM" if hour_24 < 12 else "PM"
	var hour_12 = hour_24 % 12
	if hour_12 == 0:
		hour_12 = 12

	var hour_str = str(hour_12)
	var minute_str = "%02d" % minute

	return "%s:%s %s" % [hour_str, minute_str, period]

func get_duration_string(duration: float) -> String:
	var hour_24 = get_hour_24(duration)
	var minute = get_minute(duration)

	var minute_str = "%02d" % minute

	return "%s:%s " % [hour_24, minute_str]

func get_day_string() -> String:
	return "Day %d" % current_day
