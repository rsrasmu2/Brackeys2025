extends Node3D

@export var controller: Enemy
@export var animation_player: AnimationPlayer

func enter() -> void:
	controller.un_invulnerable()
	var tween := create_tween()
	tween.tween_property($"../AngelModel", "position:y", 8, 2.0)
	$"../AngelModel/AnimationPlayer".play("spawn")
	await $"../AngelModel/AnimationPlayer".animation_finished
	controller.state = controller.EnemyState.Idle
