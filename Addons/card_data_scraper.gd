@tool
extends Node

@export var update_cards: bool = false:
	set(value):
		if true:
			print("OKAy")
			update_cards_from_sheet()

@export var url: String = "https://opensheet.elk.sh/1-W3Yr6ZREH2BvoMlhvMasoBqIs3edB3z7X2fTYE16rs/Cards"
var http_request: HTTPRequest

func update_cards_from_sheet():
	var http = HTTPRequest.new()
	add_child(http)
	var err = http.request(url)
	if err != OK:
		push_error("Failed to request sheet: %d" % err)
	http.request_completed.connect(_on_request_completed)

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var json_text = body.get_string_from_utf8()
		# Save to project folder
		var file = FileAccess.open("res://cards.json", FileAccess.WRITE)
		file.store_string(json_text)
		file.close()
		print("Saved cards.json locally")
	else:
		print("HTTP request failed with code:", response_code)
