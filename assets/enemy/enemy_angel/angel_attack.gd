extends Node3D

@export var controller: Enemy
@export var target: EnemyTarget
@export var fire_spawn_points: Array[Node3D]
@export var damage: int = 15

const LASER_SCENE := preload("res://assets/enemy/enemy_angel/angel_laser.tscn")

func enter() -> void:
	$"../AngelModel".look_at(target.target.global_position)
	for spawn_point in fire_spawn_points:
		spawn_point.look_at(target.target.global_position)
	$"../AngelModel/AnimationPlayer".connect("animation_finished", _on_animation_finished)
	$"../AngelModel/AnimationPlayer".play("attack")

func exit() -> void:
	$"../AngelModel/AnimationPlayer".disconnect("animation_finished", _on_animation_finished)

func fired() -> void:
	for spawn_point: Node3D in fire_spawn_points:
		var laser := LASER_SCENE.instantiate()
		get_tree().root.add_child(laser)
		laser.global_transform = spawn_point.global_transform
		laser.init(50, damage, controller)

func _on_animation_finished(anim_name: String) -> void:
	match anim_name:
		"attack":
			$"../AngelModel/AnimationPlayer".play("idle")
		"idle":
			controller.state = controller.EnemyState.Idle
