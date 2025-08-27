extends Node3D

@export var controller: Enemy
@export var target: EnemyTarget

@export var distance_to_follow: float = 50.0
var _sqr_follow_distance: float = distance_to_follow * distance_to_follow

@export var distance_to_attack: float = 6.0
var _sqr_attack_distance: float = distance_to_attack * distance_to_attack

func _ready() -> void:
	set_process(false)

func _process(_delta: float) -> void:
	if target.target == null:
		return
	
	var dist = global_position.distance_squared_to(target.target.global_position)
	if dist <= _sqr_attack_distance:
		controller.state = controller.EnemyState.Attacking
	elif dist <= _sqr_follow_distance:
		controller.state = controller.EnemyState.Following

func enter() -> void:
	set_process(true)

func exit() -> void:
	set_process(false)
