extends Node3D

@export var controller: Enemy
@export var target: EnemyTarget

@export var distance_to_attack: float = 1.5
var _sqr_attack_distance: float = distance_to_attack * distance_to_attack

var _min_delay: float = 0.1
var _max_delay: float = 0.8

func _ready() -> void:
	set_process(false)

func _process(_delta: float) -> void:
	if target.target == null:
		return
	
	if global_position.distance_squared_to(target.target.global_position) <= _sqr_attack_distance:
		controller.state = controller.EnemyState.Attacking
	else:
		controller.state = controller.EnemyState.Following

func enter() -> void:
	$"../Enemy_Blob/AnimationPlayer".play("idle")
	$Timer.wait_time = randf_range(_min_delay, _max_delay)
	$Timer.start()
	await $Timer.timeout
	if controller.state == controller.EnemyState.Idle:
		set_process(true)

func exit() -> void:
	set_process(false)
