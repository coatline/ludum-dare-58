class_name MarketHistory

var record_interval_minutes: int
var max_record_minutes: float
var max_ticks: int
var ticks: Array[float] = []
var market: Market

func _init(market_: Market, record_interval_minutes_: int, max_record_minutes_: float) -> void:
	market = market_
	max_record_minutes = max_record_minutes_
	record_interval_minutes = record_interval_minutes_
	max_ticks = int(max_record_minutes_ * Economy.TICKS_PER_GAME_MINUTE)
	Economy.tick_simulated.connect(tick)

func tick(current_tick: int) -> void:
	if (current_tick / Economy.TICKS_PER_GAME_MINUTE) % record_interval_minutes != 0:
		return
	
	record()

func record():
	if len(ticks) >= max_ticks:
		ticks.pop_front()
	
	ticks.append(market.current_price)
