extends Node

signal money_changed(delta_money: float)
signal bought_item(item: ItemType)

var money: float = 0

func modify_funds(amount: float):
	money += amount
	money_changed.emit(amount)
