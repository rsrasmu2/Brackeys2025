class_name Player
extends CharacterBody3D

const ACCELERATION: float = 2.0
const STOP_FORCE: float = 30.0
const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5

const GRAVITY: float = 9.8

func _physics_process(delta: float) -> void:
	# Apply gravity
	if !is_on_floor():
		velocity.y -= GRAVITY * delta
		
	move_and_slide()

func set_horizontal_velocity(direction: Vector2) -> void:
	var to_add = direction * ACCELERATION
	if to_add.x == 0:
		var target_stop = STOP_FORCE * -sign(velocity.x)
		if sign(target_stop) == sign(velocity.x):
			target_stop = -velocity.x
		to_add.x = target_stop
	if to_add.y == 0:
		var target_stop = STOP_FORCE * -sign(velocity.z)
		if sign(target_stop) == sign(velocity.z):
			target_stop = -velocity.z
		to_add.y = target_stop
	
	var target_x = clamp(velocity.x + to_add.x, -SPEED, SPEED)
	var target_z = clamp(velocity.z + to_add.y, -SPEED, SPEED)
	
	velocity.x = target_x
	velocity.z = target_z

func try_jump() -> void:
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
