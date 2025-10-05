extends Node

var resources: Dictionary = {}

@export var resource_folder: String = "res://Resources"

func _ready():
	_load_all_resources(resource_folder)
	# print("Loaded resources:", resources)

func _load_all_resources(folder_path: String):
	var dir := DirAccess.open(folder_path)
	if dir == null:
		push_error("Cannot open folder: %s" % folder_path)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			if file_name != "." and file_name != "..":
				_load_all_resources(folder_path + "/" + file_name)
		else:
			if file_name.ends_with(".tres") or file_name.ends_with(".res"):
				var res_path = folder_path + "/" + file_name
				var res = ResourceLoader.load(res_path)
				if res:
					var res_type = res.get_script()
					if res_type == null:
						res_type = res.get_class()
					
					# Use the class itself as the key if possible
					if not resources.has(res_type):
						resources[res_type] = []
					resources[res_type].append(res)
		file_name = dir.get_next()
	dir.list_dir_end()

func get_random_resource(cls: Variant) -> Resource:
	if not resources.has(cls):
		push_warning("No resources found for type: %s" % str(cls))
		return null
	
	var arr: Array = resources[cls]
	if arr.is_empty():
		push_warning("Resource list is empty for type: %s" % str(cls))
		return null

	return arr[randi() % arr.size()]
