class_name Movement
extends Node3D

signal destination_reached

@export var controller: Enemy
@export var target: EnemyTarget
var target_position: Vector3
var speed: float = 4

var _mid_attack: bool = false

func _process(delta: float) -> void:
	if not controller.is_on_floor():
		controller.velocity.y -= 9.8 * delta
	else:
		controller.velocity.y = 0
		
	if target.target == null:
		return
	
	if controller.state == controller.EnemyState.Following:
		_mid_attack = false
		var displacement: Vector3 = target.target.global_position - global_position
		var velocity: Vector2 = Vector2(displacement.x, displacement.z).normalized() * speed
		controller.velocity.x = velocity.x
		controller.velocity.z = velocity.y
	elif controller.state == controller.EnemyState.AttackingWindup:
		_mid_attack = false
		controller.velocity.x = 0
		controller.velocity.z = 0
	elif controller.state == controller.EnemyState.Attacking:
		var displacement: Vector3 = target.target.global_position - global_position
		if not _mid_attack:
			_mid_attack = true
			var velocity: Vector2 = Vector2(displacement.x, displacement.z).normalized() * speed * 2
			controller.velocity.x = velocity.x
			controller.velocity.y = 4
			controller.velocity.z = velocity.y
		elif displacement.length_squared() <= 0.1:
			emit_signal(destination_reached.get_name())
