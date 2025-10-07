@tool
extends Node

@export var update: bool = false:
	set(value):
		if value:
			_update_manifest()

@export var resource_folder: String = "res://Resources"
@export var manifest_path: String = "res://resources.json"

func _update_manifest() -> void:
	var manifest := {}
	var dir := DirAccess.open(resource_folder)
	if not dir:
		push_error("Cannot open folder: %s" % resource_folder)
		return

	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			if file_name != "." and file_name != "..":
				var subfolder_path = resource_folder + "/" + file_name
				_scan_folder(subfolder_path, manifest)
		else:
			_scan_file(file_name, resource_folder, manifest)
		file_name = dir.get_next()
	dir.list_dir_end()

	# Save JSON
	var file := FileAccess.open(manifest_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(manifest))
		file.close()
		print("Resource manifest updated at: ", manifest_path)
	else:
		push_error("Failed to write manifest to: %s" % manifest_path)

func _scan_folder(folder_path: String, manifest: Dictionary) -> void:
	var dir := DirAccess.open(folder_path)
	if not dir:
		push_error("Cannot open folder: %s" % folder_path)
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			if file_name != "." and file_name != "..":
				_scan_folder(folder_path + "/" + file_name, manifest)
		else:
			_scan_file(file_name, folder_path, manifest)
		file_name = dir.get_next()
	dir.list_dir_end()

func _scan_file(file_name: String, folder_path: String, manifest: Dictionary) -> void:
	if file_name.ends_with(".tres") or file_name.ends_with(".res"):
		var path := folder_path + "/" + file_name
		var res := ResourceLoader.load(path)
		if res:
			var cls = res.get_script() or res.get_class()
			if not manifest.has(cls):
				manifest[cls] = []
			manifest[cls].append(path)
