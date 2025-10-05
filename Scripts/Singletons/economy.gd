extends Node

const TICKS_PER_GAME_MINUTE: int = 8

signal tick_simulated(ticks: int)
signal economy_updated

var markets = {}
var total_ticks: int = 0
var last_simulated_time: int = 0

func _ready() -> void:
	var rarities = ResourceManager.get_resources(Rarity)
	for rarity in rarities:
		markets[rarity] = Market.new(rarity.base_price, 0.2, 0.00001)

func _process(delta: float) -> void:
	var updated: bool = false
	
	while int(TimeManager.total_time * TICKS_PER_GAME_MINUTE) > total_ticks:
		last_simulated_time += 1 / TICKS_PER_GAME_MINUTE

		for rarity in markets:
			markets[rarity].update_price(1.0 / TICKS_PER_GAME_MINUTE)
		
		tick_simulated.emit(total_ticks)
		updated = true
		total_ticks += 1
	
	if updated:
		economy_updated.emit()

func get_market_price(rarity: Rarity) -> float:
	if rarity in markets:
		return markets[rarity].current_price
	
	return 0.0
