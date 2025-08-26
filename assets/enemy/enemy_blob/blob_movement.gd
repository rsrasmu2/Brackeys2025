extends Node3D

@export var target: EnemyTarget
@export var controller: Enemy

const WALK_VELOCITY_Y = 3.0
const GRAVITY: float = 9.8

var target_position: Vector3
var speed: float = 4
var ground_speed: float = 0.5

func _physics_process(delta: float) -> void:
	if controller.is_on_floor():
		controller.velocity.y = 0
	else:
		controller.velocity.y -= GRAVITY * delta

func begin_walk() -> void:
	var displacement: Vector3 = target.target.global_position - global_position
	var velocity: Vector2 = Vector2(displacement.x, displacement.z).normalized() * speed
	controller.velocity.x = velocity.x
	controller.velocity.y = WALK_VELOCITY_Y
	controller.velocity.z = velocity.y

func end_walk() -> void:
	var displacement: Vector3 = target.target.global_position - global_position
	var velocity: Vector2 = Vector2(displacement.x, displacement.z).normalized() * ground_speed
	controller.velocity.x = velocity.x
	controller.velocity.z = velocity.y
