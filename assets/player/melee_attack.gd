class_name PlayerMelee
extends Node

@export var damage: int = 8
@export var cooldown: float = 1.5
@export var gun: Gun

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("melee"):
		melee()

func melee() -> void:
	if $Timer.is_stopped():
		gun.melee()
		for body: Node3D in $MeleeAttackArea.get_overlapping_bodies():
			if body.has_method("take_damage"):
				body.take_damage(damage)
		$Timer.start()
