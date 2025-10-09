class_name Market

var base_price: float
var randomness: float
var current_price: float
var demand_scale: float
var demand_recovery_strength: float
var demand_trend_inertia: float
var trend: float = 0.0

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

func _init(_base_price: float, _demand_scale: float, _randomness: float, _demand_recovery_strength: float, _demand_trend_inertia: float):
	base_price = _base_price
	randomness = _randomness
	demand_scale = _demand_scale
	demand_recovery_strength = _demand_recovery_strength
	demand_trend_inertia = _demand_trend_inertia
	current_price = base_price

func update_price(delta: float):
	# Add stronger short-term randomness
	var noise = randf_range(-1, 1) * randomness * 0.5
	
	# Small chance of larger event (rare spikes or dips)
	if randf() < 0.05:
		noise += randf_range(-1, 1) * randomness * 2.5
	
	# Correction toward base_price (mean reversion)
	var correction = ((base_price - current_price) / base_price) * demand_recovery_strength * 0.01
	
	# Momentum/trend with slight decay
	trend = trend * demand_trend_inertia + correction + noise
	
	# Clamp to avoid runaway prices
	trend = clamp(trend, -0.6, 0.6)
	
	# Apply to price with volatility
	current_price += current_price * trend * demand_scale * delta * 0.03
	
	# Prevent negative or absurd values
	current_price = max(current_price, 0.01)

func get_market_history(target_past_minutes: float) -> MarketHistory:
	var history_scale = 0
	var history: MarketHistory = histories[history_scale]
	
	while target_past_minutes > history.max_record_minutes:
		history_scale += 1
		
		if history_scale >= len(histories):
			break
		
		history = histories[history_scale]
	
	return history

func get_graph(target_past_minutes: float, history: MarketHistory, x_scale: float, y_scale: float, max_display_price: float) -> PackedVector2Array:
	var graph: PackedVector2Array = []
	
	var max_ticks = (target_past_minutes / history.record_interval_ticks) * Economy.TICKS_PER_GAME_MINUTE
	var starting_index = clamp(len(history.ticks) - max_ticks, 0, len(history.ticks))
	var tick_count = min(max_ticks, len(history.ticks))

	for i in range(starting_index, starting_index + tick_count):
		var point = Vector2((float(i - starting_index) / float(max_ticks)) * x_scale, (1 - (history.ticks[i] / max_display_price)) * y_scale)
		graph.append(point)

	return graph
