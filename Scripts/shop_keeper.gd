extends Interactable

func interact(interactor: PlayerInteractor):
	var card: CardObject = interactor.object_holder.holdable_object as CardObject
	var type: CardType = card.card_type
	
	MoneyManager.modify_funds(type.price)
	interactor.object_holder.holdable_object.queue_free()

func can_interact(interactor: PlayerInteractor) -> bool:
	if interactor.object_holder.has_item():
		var card: CardObject = interactor.object_holder.holdable_object as CardObject
		return card != null
	return false

func interact_text(interactor: PlayerInteractor) -> String:
	var card: CardObject = interactor.object_holder.holdable_object as CardObject
	var type: CardType = card.card_type
	return "Sell %s [color=green]$%.2f[/color]" % [type.display_name(), type.price]
