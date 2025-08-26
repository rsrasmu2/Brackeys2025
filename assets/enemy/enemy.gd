class_name Enemy
extends CharacterBody3D

enum EnemyState { Following, AttackingWindup, Attacking }
@onready var state: EnemyState = EnemyState.Following

func _process(delta: float) -> void:
	move_and_slide()

func take_damage(amount: int) -> void: 
	$Health.health -= amount

func _on_health_died() -> void:
	queue_free()
