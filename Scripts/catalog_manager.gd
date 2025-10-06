extends Node

signal got_new_card_type(card: CardType)
signal lost_card_type(card: CardType)

var cards: Dictionary[CardType, int] = {}

func add_card(card: CardType):
	if not cards.has(card):
		cards[card] = 1
		got_new_card_type.emit(card)
	else:
		cards[card] += 1

func remove_card(card: CardType):
	cards[card] -= 1
	
	if cards[card] <= 0:
		cards.erase(card)
		lost_card_type.emit(card)

func has_card(card: CardType) -> bool:
	return cards.has(card) && cards[card] > 0
