extends Node3D

@export var controller: Enemy
@export var animation_player: AnimationPlayer

func enter() -> void:
	$AudioStreamPlayer3D.play_pitched()
	animation_player.play("spawn")
	await animation_player.animation_finished
	controller.state = controller.EnemyState.Idle
