class_name Player
extends CharacterBody3D

const ACCELERATION: float = 20.0
const STOP_FORCE: float = 40.0
const SPEED: float = 5.0
const JUMP_VELOCITY: float = 5.5;
const SPRINT_MULT: float = 1.6
const FIRING_MULT: float = 0.7

const GRAVITY: float = 9.8

signal is_sprinting_changed(is_sprinting: bool)

var is_sprinting: bool = false:
	set(value):
		if is_sprinting != value:
			is_sprinting = value
			emit_signal(is_sprinting_changed.get_name(), is_sprinting)

var _delta: float = 0
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
	if direction == Vector2.ZERO:
		is_sprinting = false
	
	var target_velocity: Vector2 = direction * SPEED
	if _is_firing:
		target_velocity *= FIRING_MULT
	elif is_sprinting:
		target_velocity *= SPRINT_MULT
	velocity.x = target_velocity.x
	velocity.z = target_velocity.y

func try_jump() -> void:
	if is_on_floor():
		velocity.y = JUMP_VELOCITY

func _on_gun_firing_changed(is_firing: bool) -> void:
	_is_firing = is_firing
	if _is_firing and is_sprinting:
		is_sprinting = false
