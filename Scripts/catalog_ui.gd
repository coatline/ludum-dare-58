extends UIOverlay
class_name CatalogUI

const NEW_CARD_NOTIFICATION = preload("uid://csuuyt2uwexsg")
const CATALOG_ITEM = preload("uid://bwlc5dx0tjisa")
var cards_to_ui: Dictionary[CardType, CatalogItemUI] = {}

@onready var completion_text: RichTextLabel = $CompletionText
@onready var center_container: CenterContainer = $CenterContainer
@onready var grid_container: GridContainer = $CenterContainer/GridContainer
@onready var new_card_notification_holder: HBoxContainer = $"../../NewCardNotificationHolder"

func _ready() -> void:
	CatalogManager.got_new_card_type.connect(new_card_type)
	CatalogManager.lost_card_type.connect(lost_card_type)
	
	for card in ItemLibrary.cards.unsorted_array:
		var catalog_item: CatalogItemUI = CATALOG_ITEM.instantiate()
		grid_container.add_child(catalog_item)
		catalog_item.set_item(card)
		cards_to_ui[card] = catalog_item

func new_card_type(card: CardType):
	cards_to_ui[card].set_complete()
	
	var notif: NewCardNotificationUI = NEW_CARD_NOTIFICATION.instantiate()
	new_card_notification_holder.add_child(notif)
	notif.set_card(card)
	
	var finished = true
	
	for c in ItemLibrary.cards.unsorted_array:
		if CatalogManager.has_card(c) == false:
			finished = false
			break
	
	Utils.play_sound_at("NewCard", Vector3.ZERO, 1, false)

	if finished:
		print("You won!")
	
	update_progress_ui()

func lost_card_type(card: CardType):
	cards_to_ui[card].set_incomplete()
	update_progress_ui()

func update_progress_ui():
	var completed_num = 0
	for card in ItemLibrary.cards.unsorted_array:
		if CatalogManager.has_card(card):
			completed_num += 1
	completion_text.text = "[pulse]%.0f%%" % [float(completed_num) / len(ItemLibrary.cards.unsorted_array) * 100.0]
