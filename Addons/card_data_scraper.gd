@tool
extends Node

@export var update_cards: bool = false:
	set(value):
		if value:
			update_cards_from_sheet("Cards")
			update_cards_from_sheet("Items")
			update_cards_from_sheet("Card Packs")

@export var url: String = "https://opensheet.elk.sh/1-W3Yr6ZREH2BvoMlhvMasoBqIs3edB3z7X2fTYE16rs/"
var http_request: HTTPRequest

func update_cards_from_sheet(sheet: String):
	var http = HTTPRequest.new()
	add_child(http)
	
	var full_url = "%s%s" % [url, sheet]
	
	http.request_completed.connect(func(result, response_code, headers, body):
		_on_request_completed(result, response_code, headers, body, sheet)
	)
	
	var err = http.request(full_url)
	if err != OK:
		push_error("Failed to request sheet: %d" % err)
	else:
		print("Request sent to:", full_url)

func _on_request_completed(result, response_code, headers, body, sheet):
	if response_code == 200:
		var json_text = body.get_string_from_utf8()
		var file = FileAccess.open("res://%s.json" % [sheet], FileAccess.WRITE)
		file.store_string(json_text)
		file.close()
		print("Saved %s.json locally" % [sheet])
	else:
		print("HTTP request failed with code:", response_code)
