class_name Player
extends CharacterBody3D

const ACCELERATION: float = 20.0
const STOP_FORCE: float = 40.0
const SPEED: float = 5.0
const JUMP_VELOCITY: float = 5.5;

const GRAVITY: float = 9.8

var _delta: float = 0
var _in_air: bool = false

func _process(delta: float) -> void:
	_delta = delta
	var target_position = Vector3.ZERO # I hate that this can't be null
	if $Camera3D/RayCast3D.is_colliding():
		target_position = $Camera3D/RayCast3D.get_collision_point()
	else:
		target_position = $Camera3D/RayCast3D.global_position + $Camera3D/RayCast3D.global_basis.z * 100
	print(target_position)
	$Camera3D/Gun.set_aim_target(target_position)

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
	var target_velocity: Vector2 = direction * SPEED
	velocity.x = target_velocity.x
	velocity.z = target_velocity.y

func try_jump() -> void:
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
