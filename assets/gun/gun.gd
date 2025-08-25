class_name Gun
extends Node3D

const bullet_scene = preload("res://assets/bullet/bullet.tscn")
@export var cooldown: float = 0.2
@export var bullet_speed: float = 20.0

@onready var initial_rotation: Vector3 = self.rotation
var _firing: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.wait_time = cooldown

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		start_fire()
	elif event.is_action_released("fire"):
		stop_fire()

func set_aim_target(target_global_position: Vector3) -> void:
	$GunMesh/BulletSpawner.global_transform = $GunMesh/BulletSpawner.global_transform.looking_at(target_global_position)

func start_fire() -> void:
	_firing = true
	if $Timer.time_left == 0:
		fire()
	$Timer.start()

func stop_fire() -> void:
	_firing = false

func _on_timer_timeout() -> void:
	fire()

func fire() -> void:
	if _firing:
		var bullet: Bullet = bullet_scene.instantiate()
		get_tree().root.add_child(bullet)
		bullet.global_position = $GunMesh/BulletSpawner.global_position
		bullet.global_rotation = $GunMesh/BulletSpawner.global_rotation
		bullet.init(-$GunMesh/BulletSpawner.global_basis.z * bullet_speed)
	else:
		$Timer.stop()
		
