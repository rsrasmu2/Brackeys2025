class_name PlayerMelee
extends Node3D

@export var damage: int = 80
@export var knockback: float = 5
@export var gun: Gun

var _is_meleeing: bool = false

var speed_mult: float = 1.0:
	set(value):
		speed_mult = value
		gun.melee_speed_mult = speed_mult

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("melee"):
		melee()

func melee() -> void:
	if not _is_meleeing:
		_is_meleeing = true
		$MeleeWoosh.play()
		gun.melee()
		$Delay.start()
		await $Delay.timeout
		var audio_played: bool = false
		for body: Node3D in $MeleeAttackArea.get_overlapping_bodies():
			if body.has_method("take_damage"):
				var displacement := (body.global_position - global_position)
				displacement.y = 0.5
				var direction := displacement.normalized()
				body.take_damage(damage, direction * knockback, owner)
				if not audio_played:
					$MeleeHit.play()
					audio_played = true
		await gun.animations.animation_finished
		_is_meleeing = false
