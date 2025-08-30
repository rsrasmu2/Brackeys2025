extends Node3D

@export var controller: Enemy
@export var animation_player: AnimationPlayer

func enter() -> void:
	controller.knockback.y += 8.0
	animation_player.play("spawn")
	await animation_player.animation_finished
	controller.state = controller.EnemyState.Idle
