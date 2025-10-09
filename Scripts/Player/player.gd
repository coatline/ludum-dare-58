extends RigidBody3D

@export var speed = 8.0
@export var crouch_speed = 4.0
@export var accel = 16.0
@export var jump = 8.0
@export var crouch_height = 2.4
@export var crouch_transition = 8.0
@export var sensitivity = 0.2
@export var min_angle = -80
@export var max_angle = 90

@onready var jump_raycast: RayCast3D = $JumpRaycast
@onready var collision_shape = $CollisionShape3D
@onready var hand: Node3D = $Head/Hand
@onready var head: Node3D = $Head

var focused: bool = true
var stand_height: float
var look_rot: Vector2

func _ready():
	look_rot.y = rotation_degrees.y
	stand_height = collision_shape.shape.height
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	for i in range(10):
		if Input.is_key_pressed(KEY_0 + i):
			TimeManager.time_scale = i
			if i >= 2:
				TimeManager.time_scale *= i * 5
			else:
				TimeManager.time_scale = 7
	
	if Input.is_action_just_pressed("debug_reload"):
		get_tree().reload_current_scene() 
	
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		angular_velocity = Vector3.ZERO
		return
	
	var move_speed = speed
	
	if jump_raycast.is_colliding():
		if Input.is_action_just_pressed("jump"):
			linear_velocity.y = jump
		elif Input.is_action_pressed("crouch"):
			move_speed = crouch_speed
			crouch(delta, true)
		else:
			crouch(delta)

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		linear_velocity.x = lerp(linear_velocity.x, direction.x * move_speed, accel * delta)
		linear_velocity.z = lerp(linear_velocity.z, direction.z * move_speed, accel * delta)
	else:
		linear_velocity.x = lerp(linear_velocity.x, 0.0, accel * delta)
		linear_velocity.z = lerp(linear_velocity.z, 0.0, accel * delta)

	head.rotation_degrees.x = look_rot.x
	rotation_degrees.y = look_rot.y

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		look_rot.y -= (event.relative.x * sensitivity)
		look_rot.x -= (event.relative.y * sensitivity)
		look_rot.x = clamp(look_rot.x, min_angle, max_angle)

func crouch(delta : float, reverse = false):
	var target_height : float = crouch_height if not reverse else stand_height
	
	collision_shape.shape.height = lerp(collision_shape.shape.height, target_height, crouch_transition * delta)
	collision_shape.position.y = lerp(collision_shape.position.y, target_height * 0.5, crouch_transition * delta)
	head.position.y = lerp(head.position.y, target_height - 1, crouch_transition * delta)
