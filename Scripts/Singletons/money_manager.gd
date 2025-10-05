extends Node

signal money_changed(delta_money: float)

var money: float = 0

func modify_funds(amount: float):
	money += amount
	money_changed.emit(amount)
