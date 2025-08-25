class_name Player
extends CharacterBody3D

const ACCELERATION: float = 20.0
const STOP_FORCE: float = 40.0
const SPEED: float = 5.0
const JUMP_VELOCITY: float = 5.5
const FIRING_MULT: float = 0.7

const GRAVITY: float = 9.8

var current_dash_speed: float = 0:
	set(value):
		if current_dash_speed != value:
			current_dash_speed = value
			velocity.x = _target_velocity.x * current_dash_speed
			velocity.y = 0
			velocity.z = _target_velocity.y * current_dash_speed
	
var is_dashing: bool:
	get():
		return current_dash_speed != 0

var _delta: float = 0
var _target_velocity: Vector2
var _in_air: bool = false
var _is_firing: bool = false

func _process(delta: float) -> void:
	_delta = delta
	var target_position: Vector3 = Vector3.ZERO # I hate that this can't be null
	if $PlayerCamera/RayCast3D.is_colliding():
		target_position = $PlayerCamera/RayCast3D.get_collision_point()
	else:
		target_position = $PlayerCamera/RayCast3D.global_position + $PlayerCamera/RayCast3D.global_basis.z * 100
	$PlayerCamera/Gun.set_aim_target(target_position)

func _physics_process(delta: float) -> void:
	# Apply gravity
	if !is_on_floor():
		_in_air = true
		velocity.y -= GRAVITY * delta
	elif _in_air && is_on_floor():
		_in_air = false
		velocity.y = 0
		
	move_and_slide()

func set_horizontal_velocity(direction: Vector2) -> void:
	_target_velocity = direction * SPEED
	print(_target_velocity)
	var target_velocity: Vector2 = _target_velocity
	if _is_firing:
		target_velocity *= FIRING_MULT
	if not is_dashing:
		velocity.x = target_velocity.x
		velocity.z = target_velocity.y

func try_jump() -> void:
	if is_on_floor():
		velocity.y = JUMP_VELOCITY

func _on_gun_firing_changed(is_firing: bool) -> void:
	_is_firing = is_firing
