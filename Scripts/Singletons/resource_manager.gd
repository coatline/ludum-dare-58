extends Node

var resources: Dictionary = {}

@export var manifest_path: String = "res://resources.json"

func _ready():
	_load_resources_from_manifest()
	print("LOADED SOUNDS:", len(get_resources(Sound)))
#
#func _on_request_completed(result, response_code, headers, body, sheet):
	#var json_text = body.get_string_from_utf8()
	#var file = FileAccess.open("res://%s.json" % [sheet], FileAccess.WRITE)
	#file.store_string(json_text)
	#file.close()


func _load_resources_from_manifest():
	if FileAccess.file_exists(manifest_path):
		var file = FileAccess.open(manifest_path, FileAccess.READ)
		var json_text = file.get_as_text()
		file.close()

		var result = JSON.parse_string(json_text)
		if result == null:
			push_error("Failed to parse JSON")
			return

		var data = result
		
		for cls_name in data.keys():
			var paths = data[cls_name]
			
			for path in paths:
				var res = ResourceLoader.load(path)
				if res:
					var cls = res.get_script()
					
					if not resources.has(cls):
						resources[cls] = []
					resources[cls].append(res)
				else:
					print("Couldn't load %s" % path)
	else:
		push_error("Manifest not found: %s" % manifest_path)

func get_resources(cls: Variant) -> Array:
	return resources.get(cls, [])

func get_random_resource(cls: Variant) -> Resource:
	var arr = get_resources(cls)
	if arr.empty():
		push_warning("No resources found for type: %s" % str(cls))
		return null
	return arr[randi() % arr.size()]
