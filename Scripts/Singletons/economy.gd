extends Node

const TICKS_PER_GAME_MINUTE: int = 3

signal tick_simulated(ticks: int)
signal economy_updated

var card_to_market: Dictionary[CardType, Market] = {}
var total_ticks: int = 0
var last_simulated_time: int = 0

func _ready() -> void:
	for card: CardType in ItemLibrary.cards.unsorted_array:
		card_to_market[card] = Market.new(card.price, card.demand_scale, card.demand_randomness, card.demand_recovery_strength, card.demand_trend_inertia)

func _process(delta: float) -> void:
	var updated: bool = false
	
	while int(TimeManager.total_time * TICKS_PER_GAME_MINUTE) > total_ticks:
		last_simulated_time += 1 / TICKS_PER_GAME_MINUTE
	
		for market in card_to_market.values():
			market.update_price(1.0 / TICKS_PER_GAME_MINUTE)
		
		tick_simulated.emit(total_ticks)
		updated = true
		total_ticks += 1
	
	if updated:
		economy_updated.emit()
