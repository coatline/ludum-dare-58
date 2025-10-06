extends Interactable

@export var object_holder: ObjectHolder

func interact(interactor: PlayerInteractor):
	var player_item: HoldableObject = interactor.object_holder.holdable_object
	
	# Take item
	if player_item:
		interactor.object_holder.try_drop(0)

		if object_holder.has_item():
			var previous_item: HoldableObject = object_holder.holdable_object
			object_holder.try_drop(0)
			interactor.object_holder.pickup(previous_item)
		
		Utils.play_sound_at("ThrowObject", Vector2.ZERO, 1, false)
		object_holder.pickup(player_item)

	elif object_holder.has_item():
		var previous_item: HoldableObject = object_holder.holdable_object
		object_holder.try_drop(0)
		interactor.object_holder.pickup(previous_item)
		Utils.play_sound_at("ThrowObject", Vector2.ZERO, 1, false)


func can_interact(interactor: PlayerInteractor) -> bool:
	if interactor.object_holder.has_item():
		return interactor.object_holder.holdable_object != null
	return object_holder.has_item()

func interact_text(interactor: PlayerInteractor) -> String:
	var item: HoldableObject = interactor.object_holder.holdable_object
	
	if item:
		return "Store [color=%s]%s[/color]" % [
		item.text_color().to_html(),
		item.display_name
		]
	elif object_holder.has_item():
		return "Take [color=%s]%s[/color]" % [
		object_holder.holdable_object.text_color().to_html(),
		object_holder.holdable_object.display_name
		]
	
	return ""
