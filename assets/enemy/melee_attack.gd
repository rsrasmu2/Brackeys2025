extends Node3D

@export var character_controller: Enemy
@export var target: EnemyTarget
@export var movement: Movement
@export var distance_to_attack: float = 5.0
@export var animation_player: AnimationPlayer

var sqr_distance: float = distance_to_attack * distance_to_attack

func _process(_delta: float) -> void:
	if character_controller.state == character_controller.EnemyState.Following and target.target != null and global_position.distance_squared_to(target.target.global_position) <= sqr_distance:
		character_controller.state = character_controller.EnemyState.AttackingWindup
		animation_player.play("melee_windup")
		$WindupTimer.start()

func _on_windup_timer_timeout() -> void:
	character_controller.state = character_controller.EnemyState.Attacking
	await $"../AnimationPlayer".animation_finished
	animation_player.play("melee_end")
	await $"../AnimationPlayer".animation_finished
	character_controller.state = character_controller.EnemyState.Following
