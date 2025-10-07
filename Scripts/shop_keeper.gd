extends Interactable

func interact(interactor: PlayerInteractor):
	var card: CardObject = interactor.object_holder.holdable_object as CardObject
	var card_type: CardType = card.card_type
	
	MoneyManager.modify_funds(Economy.card_to_market[card_type].current_price)
	interactor.object_holder.holdable_object.queue_free()
	Utils.play_sound_at("Sell", Vector2.ZERO, 1, false)

func can_interact(interactor: PlayerInteractor) -> bool:
	if interactor.object_holder.has_item():
		var card: CardObject = interactor.object_holder.holdable_object as CardObject
		return card != null
	return false

func interact_text(interactor: PlayerInteractor) -> String:
	var card: CardObject = interactor.object_holder.holdable_object as CardObject
	var type: CardType = card.card_type
	return "Sell [color=%s]%s[/color] for [color=green]$%.2f[/color]" % [
	Utils.get_rarity_color(type.rarity).to_html(),
	type.name,
	Economy.card_to_market[type].current_price
]
