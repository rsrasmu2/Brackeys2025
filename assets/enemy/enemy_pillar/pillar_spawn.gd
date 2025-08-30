extends Node3D

@export var controller: EnemyPillar

var velocity = 16
var acceleration = -9.8

func _ready() -> void:
	set_physics_process(false)

func enter() -> void:
	set_physics_process(true)
	$"../GroundDetection".monitoring = false
	$"../CollisionShape3D".disabled = true
	controller.global_position.y -= 8

func exit() -> void:
	set_physics_process(false)
	$"../GroundDetection".monitoring = true
	$"../CollisionShape3D".disabled = false

func _physics_process(delta: float) -> void:
	controller.global_position.y += velocity * delta
	velocity += acceleration * delta
	if velocity <= 0:
		controller.state = controller.EnemyState.Idle
		
