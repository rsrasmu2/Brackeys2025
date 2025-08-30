extends Node3D

@export var controller: Enemy
@export var animation_player: AnimationPlayer
@export var health_bar: Node3D

func enter() -> void:
	$AudioStreamPlayer3D.play_pitched()
	animation_player.play("dying")
	health_bar.change_visibility = false
	health_bar.visible = false
	await animation_player.animation_finished
	controller.queue_free()
