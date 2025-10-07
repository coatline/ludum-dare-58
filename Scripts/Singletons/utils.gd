extends Node

func get_item_string(holdable_object: HoldableObject) -> String:
	return "[color=%s]%s[/color]" % [holdable_object.text_color().to_html(), holdable_object.display_name]

func color_string(message: String, color: Color):
	return "[color=%s]%s[/color]" % [color.to_html(), message]

func get_verb_item_string(message: String, holdable_object: HoldableObject) -> String:
	return "%s[color=%s]%s[/color]" % [message, holdable_object.text_color().to_html(), holdable_object.display_name]

func _apply_texture_to_face(face_mesh: MeshInstance3D, tex: Texture2D):
	var mat := get_new_material()
	mat.albedo_texture = tex
	face_mesh.set_surface_override_material(0, mat)

func get_new_material() -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST  # keeps pixel-art sharp
	mat.uv1_scale = Vector3.ONE # ensures full texture is shown
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED     # optional: makes it 2D-looking
	return mat

func play_sound_at(sound_name: String, position = null, volume: float = SoundManager.DEFAULT_VOLUME, spatial: bool = true):
	var sounds = ResourceManager.get_resources(Sound)
	for sound: Sound in sounds:
		if sound.name == sound_name:
			SoundManager.PlaySound(sound.get_random_sound(), position, volume, spatial)

func get_rarity_color(rarity: String) -> Color:
	match rarity:
		"Common":
			return Color(0.8, 0.8, 0.8) # White
		"Uncommon":
			return Color(0, 1, 0) # Green
		"Rare":
			return Color(0, 1, 1) # Blue
		"Epic":
			return Color(0.6, 0, 0.8) # Purple
		"Legendary":
			return Color(1, 0.5, 0) # Orange
		_:
			return Color(0, 0, 0) # Default to black
