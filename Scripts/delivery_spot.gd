extends Node3D

func _ready() -> void:
	MoneyManager.bought_item.connect(deliver)

func deliver(item: ItemType):
	var instance: Node3D = item.scene.instantiate()
	add_child(instance)
	instance.global_position = global_position
	
	var card = instance as CardObject
	
	if card:
		card.set_card_type(item as CardType)
		return
	
	var card_pack = instance as CardPack
	
	if card_pack:
		card_pack.set_type(item as CardPackType)
