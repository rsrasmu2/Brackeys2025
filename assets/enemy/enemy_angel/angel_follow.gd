extends Node3D

@export var target: EnemyTarget
@export var controller: Enemy

var speed: float = 4

@export var attack_range: float = 40
@export var animation_player: AnimationPlayer
@export var rotation_speed: float = 3

@onready var _sqr_attack_range: float = attack_range * attack_range

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func _process(delta: float) -> void:
	var direction := (target.target.global_position - global_position).normalized()
	var slerped: Vector3 = (-$"../AngelModel".global_basis.z).slerp(direction, delta * rotation_speed)
	if slerped.length_squared() <= 0.05:
		return
	$"../AngelModel".look_at($"../AngelModel".global_position + slerped)

func _physics_process(_delta: float) -> void:
	var displacement: Vector3 = target.target.global_position - global_position
	var velocity: Vector2 = Vector2(displacement.x, displacement.z).normalized() * speed
	controller.target_velocity.x = velocity.x
	controller.target_velocity.z = velocity.y

func enter() -> void:
	set_physics_process(true)
	set_process(true)
	animation_player.connect("animation_finished", _on_animation_finished)
	animation_player.play("run_start")

func exit() -> void:
	set_physics_process(false)
	set_process(false)
	animation_player.disconnect("animation_finished", _on_animation_finished)
	controller.target_velocity.x = 0
	controller.target_velocity.z = 0

func _on_animation_finished(anim_name: String) -> void:
	match anim_name:
		"run_start":
			if global_position.distance_squared_to(target.target.global_position) <= _sqr_attack_range:
				animation_player.play("run_end")
			else:
				animation_player.play("run_idle")
		"run_idle":
			if global_position.distance_squared_to(target.target.global_position) <= _sqr_attack_range:
				animation_player.play("run_end")
			else:
				animation_player.play("run_idle")
		"run_end":
			if global_position.distance_squared_to(target.target.global_position) <= _sqr_attack_range:
				controller.state = controller.EnemyState.Attacking
			else:
				animation_player.play("run_start")
