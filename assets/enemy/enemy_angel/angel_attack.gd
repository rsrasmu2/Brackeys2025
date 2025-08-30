extends Node3D

@export var controller: Enemy
@export var target: EnemyTarget
@export var fire_spawn_points: Array[Node3D]
@export var damage: int = 15
@export var rotation_speed: float = 180

const LASER_SCENE := preload("res://assets/enemy/enemy_angel/angel_laser.tscn")

var _should_fire: bool = false

func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	var target_pos: Vector3 = target.target.global_transform.origin
	
	var desired_x: Transform3D = $"../AngelModel".global_transform.looking_at(target_pos, Vector3.UP)
	var from: Quaternion = $"../AngelModel".global_transform.basis.get_rotation_quaternion()
	var to: Quaternion = desired_x.basis.get_rotation_quaternion()
	
	var angle := from.angle_to(to)
	if _should_fire and angle <= PI / 32.0:
		set_process(false)
		$"../AngelModel".look_at(target.target.global_position)
		for spawn_point in fire_spawn_points:
			spawn_point.look_at(target.target.global_position)
		$"../AngelModel/AnimationPlayer".play("attack")
		$AudioStreamPlayer3D.play_pitched()
		return
	
	var max_step := deg_to_rad(rotation_speed) * delta
	var t: float = min(1.0, max_step / angle)
	var new: Quaternion = from.slerp(to, t)
	$"../AngelModel".global_transform.basis = Basis(new)

func enter() -> void:
	_should_fire = true
	$"../AngelModel/AnimationPlayer".connect("animation_finished", _on_animation_finished)
	set_process(true)

func exit() -> void:
	set_process(false)
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
			_should_fire = false
			set_process(true)
			$"../AngelModel/AnimationPlayer".play("idle")
		"idle":
			controller.state = controller.EnemyState.Idle
