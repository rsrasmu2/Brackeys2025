class_name Gun
extends Node3D

signal firing_changed(is_firing: bool)
signal ammo_changed(ammo: int)
signal current_ammo_changed(current_ammo: int)
signal started_reloading
signal finished_reloading

const bullet_scene = preload("res://assets/bullet/bullet.tscn")
@export var cooldown: float = 0.2:
	set(value):
		cooldown = value
		$FireTimer.wait_time = cooldown

@export var bullet_speed: float = 20.0
@export var bullet_damage: int = 30
@export var ammo: int = 16:
	set(value):
		if ammo != value:
			ammo = value
			emit_signal(ammo_changed.get_name(), ammo)
			if current_ammo > ammo:
				current_ammo = ammo

@export var reload_speed: float = 1.2:
	set(value):
		reload_speed = value
		$ReloadTimer.wait_time = reload_speed

@onready var current_ammo: int = self.ammo:
	set(value):
		var new_ammo: int = clamp(value, 0, ammo)
		if current_ammo != new_ammo:
			current_ammo = new_ammo
			emit_signal(current_ammo_changed.get_name(), current_ammo)

@onready var initial_rotation: Vector3 = self.rotation
var _firing: bool = false:
	set(value):
		if _firing != value:
			_firing = value
			emit_signal(firing_changed.get_name(), _firing)

var _reloading: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$FireTimer.wait_time = cooldown
	$ReloadTimer.wait_time = reload_speed

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		start_fire()
	elif event.is_action_released("fire"):
		stop_fire()
	if event.is_action_pressed("reload"):
		reload()

func set_aim_target(target_global_position: Vector3) -> void:
	$GunMesh/BulletSpawner.global_transform = $GunMesh/BulletSpawner.global_transform.looking_at(target_global_position)

func start_fire() -> void:
	_firing = true
	if $FireTimer.is_stopped():
		fire()
		$FireTimer.start()

func stop_fire() -> void:
	_firing = false

func _on_timer_timeout() -> void:
	if not _firing:
		$FireTimer.stop()
	else:
		fire()

func fire() -> void:
	if current_ammo == 0:
		reload()
		return
		
	var bullet: Bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_position = $GunMesh/BulletSpawner.global_position
	bullet.global_rotation = $GunMesh/BulletSpawner.global_rotation
	bullet.init(-$GunMesh/BulletSpawner.global_basis.z * bullet_speed, bullet_damage)
	current_ammo -= 1
	
func reload() -> void:
	if _reloading:
		return
	$FireTimer.stop()
	_reloading = true
	$ReloadTimer.start()
	emit_signal(started_reloading.get_name())


func _on_reload_timer_timeout() -> void:
	current_ammo = ammo
	_reloading = false
	emit_signal(finished_reloading.get_name())
	if _firing:
		fire()
		$FireTimer.start()
