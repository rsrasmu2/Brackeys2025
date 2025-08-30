extends Node3D

@export var controller: Enemy
@export var animation_player: AnimationPlayer
@export var health_bar: Node3D

func enter() -> void:
	animation_player.play("death")
	health_bar.visible = false
	await animation_player.animation_finished
	controller.queue_free()
