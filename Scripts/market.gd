class_name Market

var base_price: float
var volatility: float
var current_price: float
var recovery_speed: float
# if I wanted to simulate a crash in the market, I could lower demand temporarily
var demand: float = 1.0

var histories = [
	# 1 Hour
	MarketHistory.new(self, 1, 60),
	# 1 Week
	MarketHistory.new(self, Economy.TICKS_PER_GAME_MINUTE, 10080),
	# 1 Month
	MarketHistory.new(self, Economy.TICKS_PER_GAME_MINUTE * 30, 43200),
	# 1 Year
	MarketHistory.new(self, 365, 525600)
]

func _init(_base_price: float = 50.0, _volatility: float = 1, _recovery_speed: float = 0.000001):
	base_price = _base_price
	volatility = _volatility
	recovery_speed = _recovery_speed
	current_price = base_price

func update_price(delta: float):
	# Random fluctuation scaled by demand
	var random_change = randf_range(-volatility, volatility) * demand * delta

	# Recovery toward base_price scaled by demand
	var recovery_change = (base_price - current_price) * recovery_speed * demand * delta
	current_price += random_change + recovery_change
	current_price = max(current_price, 0.01)

func get_graph(target_past_minutes: float, x_scale: float, y_scale: float, max_price: float) -> PackedVector2Array:
	var graph: PackedVector2Array = []
	
	var history_scale = 0
	var history: MarketHistory = histories[history_scale]
	
	while target_past_minutes > history.max_record_minutes:
		history_scale += 1
		
		if history_scale >= len(histories):
			break
		
		history = histories[history_scale]
	
	var max_ticks = (target_past_minutes / history.record_interval_ticks) * Economy.TICKS_PER_GAME_MINUTE
	var starting_index = clamp(len(history.ticks) - max_ticks, 0, len(history.ticks))
	var tick_count = min(max_ticks, len(history.ticks))

	for i in range(starting_index, starting_index + tick_count):
		var point = Vector2((float(i - starting_index) / float(max_ticks)) * x_scale, (1 - (history.ticks[i] / max_price)) * y_scale)
		graph.append(point)

	return graph
