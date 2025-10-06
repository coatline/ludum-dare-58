extends Node

var cards: Array = []

func _ready():
	load_cards()

func load_cards():
	if not FileAccess.file_exists("res://cards.json"):
		print("cards.json not found!")
		return
	
	var file = FileAccess.open("res://cards.json", FileAccess.READ)
	var json_text = file.get_as_text()
	file.close()

	var data = JSON.parse_string(json_text)
	if data == null:
		print("Error parsing JSON")
		return

	for row in data:
		cards.append(CardType.new(row))
	print("Loaded %d cards" % cards.size())

func get_card_by_name(name_: String) -> CardType:
	for c in cards:
		if c.name == name_:
			return c
	return null
