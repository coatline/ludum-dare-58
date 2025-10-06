class_name Market

var base_price: float
var volatility: float
var current_price: float
var recovery_speed: float
var trend: float = 0.0
var max_price: float = 1000.0
var min_price: float = 0.01
var noise = FastNoiseLite.new()
var noise_offset = randi()

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
	max_price = base_price * 1.25
	min_price = base_price * 0.75
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.seed = randi()

func update_price(delta: float):
	var recovery_speed = 0.2
	var randomness = 0.05
	var trend_inertia = 0.99  # how much trend “sticks”
	var correction_strength = 0.01  # pull toward base price
	var volatility = 0.02  # how jumpy it is

	# random drift like daily ups/downs
	var random_drift = randf_range(-randomness, randomness)

	# recovery: cheap stocks tend to rise, expensive tend to drop
	var correction = ((base_price - current_price) / base_price) * correction_strength

	# gradual trend change (momentum + random noise)
	trend = trend * trend_inertia + random_drift + correction

	# apply volatility and clamp trend a bit
	trend = clamp(trend, -0.5, 0.5)

	# update price
	current_price += current_price * trend * volatility * delta * 0.5

	# keep within min/max bounds
	current_price = current_price

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
