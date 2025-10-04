extends RichTextLabel

func _ready() -> void:
	MoneyManager.money_changed.connect(update_text)

func update_text(delta_money: float):
	text = "$%.2f" % [MoneyManager.money]
