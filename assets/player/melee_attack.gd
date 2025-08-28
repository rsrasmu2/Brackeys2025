class_name PlayerMelee
extends Node3D

@export var damage: int = 80
@export var knockback: float = 5
@export var cooldown: float = 0.6
@export var gun: Gun

func _ready() -> void:
	$Timer.wait_time = cooldown

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("melee"):
		melee()

func melee() -> void:
	if $Timer.is_stopped():
		gun.melee()
		for body: Node3D in $MeleeAttackArea.get_overlapping_bodies():
			if body.has_method("take_damage"):
				var displacement := (body.global_position - global_position)
				displacement.y = 0.5
				var direction := displacement.normalized()
				body.take_damage(damage, direction * knockback, owner)
		$Timer.start()
