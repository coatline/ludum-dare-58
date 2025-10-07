extends Node

var card_packs: ItemShelf
var cards: ItemShelf
var items: ItemShelf

func _ready():
	card_packs = ItemShelf.new("res://Card Packs.json", CardPackType)
	items = ItemShelf.new("res://Items.json", ItemType)
	cards = ItemShelf.new("res://Cards.json", CardType)
