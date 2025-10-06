extends Panel
class_name CatalogItemUI

const CHECKMARK = preload("uid://f8r828iaivte")
const X_MARK = preload("uid://deryh5g220smb")

@onready var item_name: RichTextLabel = $ItemName
@onready var status: TextureRect = $Image/Status
@onready var image: TextureRect = $Image

func set_item(item: ItemType):
	image.texture = item.texture
	item_name.text = item.display_name()

func set_complete():
	image.self_modulate = Color.WHITE
	status.texture = CHECKMARK

func set_incomplete():
	image.self_modulate = Color.DIM_GRAY
	status.texture = X_MARK
