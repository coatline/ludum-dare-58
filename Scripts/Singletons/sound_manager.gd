extends Node

const INITIAL_POOL_SIZE := 0
const DEFAULT_VOLUME := 1.0

var pool_2d: Array[AudioStreamPlayer2D] = []
var pool_3d: Array[AudioStreamPlayer3D] = []
var pool_non_spatial: Array[AudioStreamPlayer] = []

func _ready():
	for i in range(INITIAL_POOL_SIZE):
		_add_to_pool_2d()
		_add_to_pool_3d()
		_add_to_pool_non_spatial()

func _add_to_pool_2d() -> AudioStreamPlayer2D:
	var player = AudioStreamPlayer2D.new()
	player.bus = "SFX"
	player.finished.connect(func(): _return_to_pool.bind(player, pool_2d))
	add_child(player)
	pool_2d.append(player)
	return player

func _add_to_pool_3d() -> AudioStreamPlayer3D:
	var player = AudioStreamPlayer3D.new()
	player.bus = "SFX"
	player.finished.connect(func(): _return_to_pool.bind(player, pool_3d))
	add_child(player)
	pool_3d.append(player)
	return player

func _add_to_pool_non_spatial() -> AudioStreamPlayer:
	var player = AudioStreamPlayer.new()
	player.bus = "SFX"
	player.finished.connect(func(): _return_to_pool.bind(player, pool_non_spatial))
	add_child(player)
	pool_non_spatial.append(player)
	return player

func _get_player_from_pool(pool: Array, add_func: Callable):
	for player in pool:
		if not player.playing:
			return player
	# All busy — add one more and return it
	return add_func.call()

func _return_to_pool(player: AudioStreamPlayer, pool: Array):
	player.stop()
	player.stream = null

func PlaySound(stream: AudioStream, position = null, volume: float = DEFAULT_VOLUME, spatial: bool = true):
	if stream == null:
		print("NULL STREAM!")
		return

	if spatial:
		if position is Vector2:
			var player = _get_player_from_pool(pool_2d, _add_to_pool_2d)
			player.stream = stream
			player.position = position
			player.volume_db = linear_to_db(volume)
			player.play()
		elif position is Vector3:
			var player = _get_player_from_pool(pool_3d, _add_to_pool_3d)
			player.stream = stream
			player.position = position
			player.volume_db = linear_to_db(volume)
			player.play()
		else:
			push_error("Spatial sound requires Vector2 or Vector3 position.")
	else:
		var player = _get_player_from_pool(pool_non_spatial, _add_to_pool_non_spatial)
		player.stream = stream
		player.volume_db = linear_to_db(volume)
		player.play()
