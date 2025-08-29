extends Node3D

@export var controller: Enemy
@export var target: EnemyTarget

const LASER_SCENE := preload("res://assets/enemy/enemy_angel/angel_laser.tscn")

func enter() -> void:
	$"../AngelModel".look_at(target.target.global_position)
	$"../AngelModel/AnimationPlayer".connect("animation_finished", _on_animation_finished)
	$"../AngelModel/AnimationPlayer".play("attack")

func fired() -> void:
	pass

func _on_animation_finished(anim_name: String) -> void:
	controller.state = controller.EnemyState.Idle
