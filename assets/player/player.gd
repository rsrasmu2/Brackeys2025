class_name Player
extends CharacterBody3D

const ACCELERATION: float = 20.0
const STOP_FORCE: float = 40.0
const SPEED: float = 5.0
const FIRING_MULT: float = 0.7

const GRAVITY: float = 9.8

var current_dash_speed: float = 0:
	set(value):
		if current_dash_speed != value:
			current_dash_speed = value
	
var is_dashing: bool:
	get():
		return current_dash_speed != 0

var _delta: float = 0
var _target_velocity: Vector2
var _in_air: bool = false
var _is_firing: bool = false

var gravity_effect: float = 0
var knockback: Vector3 = Vector3.ZERO

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
		if not is_dashing:
			gravity_effect = GRAVITY
		else:
			gravity_effect = 0
			velocity.y = 0
	elif _in_air && is_on_floor():
		_in_air = false
		gravity_effect = 0
		velocity.y = 0
	
	velocity.x = _target_velocity.x * (1 + current_dash_speed)
	velocity.y -= gravity_effect * delta
	velocity.z = _target_velocity.y * (1 + current_dash_speed)
	velocity += knockback
	
	move_and_slide()

func set_horizontal_velocity(direction: Vector2) -> void:
	_target_velocity = direction * SPEED
	if _is_firing:
		_target_velocity *= FIRING_MULT

func _on_gun_firing_changed(is_firing: bool) -> void:
	_is_firing = is_firing

func take_damage(amount: int, knockback_amount: Vector3) -> void:
	$Health.health -= amount
	$Knockback.add_knockback(knockback_amount)

func _on_health_died() -> void:
	set_process(false)
	set_physics_process(false)
