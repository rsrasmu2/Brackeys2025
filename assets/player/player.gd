class_name Player
extends CharacterBody3D

const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5

func _physics_process(delta: float) -> void:
	move_and_slide()

func set_horizontal_velocity(direction: Vector2) -> void:
	velocity.x = direction.x * SPEED
	velocity.z = direction.y * SPEED
