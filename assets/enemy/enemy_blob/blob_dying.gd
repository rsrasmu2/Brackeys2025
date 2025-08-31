extends Node3D

@export var controller: Enemy
@export var animation_player: AnimationPlayer
@export var health_bar: Node3D

func enter() -> void:
	controller.invulnerable = true
	health_bar.change_visibility = false
	health_bar.visible = false
	$"../Health".queue_free()
	animation_player.play("death")
	await animation_player.animation_finished
	controller.queue_free()
