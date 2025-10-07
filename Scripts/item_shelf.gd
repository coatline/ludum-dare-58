class_name ItemShelf

var items_by_name: Dictionary[String, Variant]
var items_by_id: Dictionary[int, Variant]
var unsorted_array : Array[Variant]
var length: int = 0

func _init(json_path: String, type: Variant) -> void:
	load_items_from_json(json_path, type)
	_initialize(unsorted_array)

func load_items_from_json(json_path: String, type: Variant) -> void:
	if not FileAccess.file_exists(json_path):
		print("%s not found!" % json_path)
		return

	var file = FileAccess.open(json_path, FileAccess.READ)
	var json_text = file.get_as_text()
	file.close()

	var data = JSON.parse_string(json_text)
	if data == null:
		print("Error parsing JSON")
		return

	for row in data:
		unsorted_array.append(type.new(row))
	
	print("Loaded %d %s" % [unsorted_array.size(), json_path])

func _initialize(items: Array[Variant]) -> void:
	for item in items:
		if not item:
			print("Null Data!")
			continue
		
		#print("adding is %s for %s"  % [item.id, item.name])
		items_by_name[item.name] = item
		items_by_id[item.id] = item

func get_by_name(name: String):
	if items_by_name.has(name):
		return items_by_name[name]
	push_error("Couldn't get %s" % name)
	return null

func get_by_index(idx: int):
	if idx >= 0 and idx < length:
		return unsorted_array[idx]
	return null

func get_random(excluding: Array = []):
	var pool = unsorted_array.duplicate()
	for e in excluding:
		pool.erase(e)
	if pool.size() == 0:
		return null
	return pool[randi() % pool.size()]

func get_by_id(id: int):
	if items_by_id.has(id):
		return items_by_id[id]
	return null
