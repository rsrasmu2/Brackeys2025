extends Node3D

@export var controller: EnemyPillar
@export var target: EnemyTarget

@export var distance_to_follow: float = 50.0
var _sqr_follow_distance: float = distance_to_follow * distance_to_follow

@export var distance_to_attack: float = 7.0
var _sqr_attack_distance: float = distance_to_attack * distance_to_attack

var forward: Vector3:
	get():
		if $"../MeshOrigin/Enemy_Pillar/EndDetectionTop".global_position.y > $"../MeshOrigin/Enemy_Pillar/EndDetectionBottom".global_position.y:
			return $"../MeshOrigin/Enemy_Pillar/EndDetectionBottom".global_basis.z
		else:
			return $"../MeshOrigin/Enemy_Pillar/EndDetectionTop".global_basis.z

func _ready() -> void:
	set_process(false)

func _process(_delta: float) -> void:
	if target.target == null:
		return
	
	var dist := global_position.distance_squared_to(target.target.global_position)
	if dist <= _sqr_attack_distance:
		if forward.dot((target.target.global_position - global_position).normalized()) < 0.2:
			controller.state = controller.EnemyState.Attacking
		else:
			controller.state = controller.EnemyState.Following
	elif dist <= _sqr_follow_distance:
		controller.state = controller.EnemyState.Following

func enter() -> void:
	set_process(true)

func exit() -> void:
	set_process(false)
