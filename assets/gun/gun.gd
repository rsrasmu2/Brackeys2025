class_name Gun
extends Node3D

signal max_ammo_changed(ammo: int)
signal current_ammo_changed(current_ammo: int)
signal started_reloading
signal finished_reloading

signal fired(bullet: Bullet)

enum GunState {
	Idle,
	Firing,
	Reloading,
	Meleeing,
}
var _state: GunState = GunState.Idle

const bullet_scene = preload("res://assets/bullet/bullet.tscn")
@export var cooldown: float = 0.2:
	set(value):
		cooldown = value
		$FireTimer.wait_time = cooldown

@export var bullet_speed: float = 20.0
@export var bullet_damage: int = 30
@export var max_ammo: int = 16:
	set(value):
		if max_ammo != value:
			max_ammo = value
			emit_signal(max_ammo_changed.get_name(), max_ammo)
			if current_ammo > max_ammo:
				current_ammo = max_ammo

@export var reload_speed_mult: float = 1.0
@export var melee_speed_mult: float = 1.0

@onready var current_ammo: int = self.max_ammo:
	set(value):
		var new_ammo: int = clamp(value, 0, max_ammo)
		if current_ammo != new_ammo:
			current_ammo = new_ammo
			emit_signal(current_ammo_changed.get_name(), current_ammo)

@onready var initial_rotation: Vector3 = self.rotation

var _fire_held: bool = false

var bullet_spawner: Node3D:
	get():
		return $GunMesh/BulletSpawner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$FireTimer.wait_time = cooldown

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		_fire_held = true
		start_fire()
	elif event.is_action_released("fire"):
		_fire_held = false
		stop_fire()
	if event.is_action_pressed("reload"):
		reload()

func set_aim_target(target_global_position: Vector3) -> void:
	$GunMesh/BulletSpawner.global_transform = $GunMesh/BulletSpawner.global_transform.looking_at(target_global_position)

func start_fire() -> void:
	if _state != GunState.Idle:
		return
	_state = GunState.Firing
	if $FireTimer.is_stopped():
		fire()
		$FireTimer.start()

func stop_fire() -> void:
	if _state != GunState.Firing:
		return
	_state = GunState.Idle

func _on_timer_timeout() -> void:
	if _state != GunState.Firing:
		$FireTimer.stop()
	else:
		fire()

func fire() -> void:
	if current_ammo == 0:
		reload()
		return
	var bullet: Bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_position = bullet_spawner.global_position
	bullet.global_rotation = bullet_spawner.global_rotation
	bullet.init(-bullet_spawner.global_basis.z * bullet_speed, bullet_damage, 0)
	current_ammo -= 1
	emit_signal(fired.get_name(), bullet)

func reload() -> void:
	if _state == GunState.Reloading or _state == GunState.Meleeing:
		return
	if current_ammo == max_ammo:
		return
	$FireTimer.stop()
	_state = GunState.Reloading
	$Animations.speed_scale = reload_speed_mult
	$Animations.play("reload")
	emit_signal(started_reloading.get_name())

func _on_reload_finished() -> void:
	current_ammo = max_ammo
	_state = GunState.Idle
	emit_signal(finished_reloading.get_name())
	if _fire_held:
		start_fire()

func melee() -> void:
	if _state == GunState.Meleeing:
		return
	_state = GunState.Meleeing
	$Animations.speed_scale = melee_speed_mult
	$Animations.play("melee")


func _on_animations_animation_finished(anim_name: StringName) -> void:
	if anim_name == "reload":
		_on_reload_finished()
	if anim_name == "melee":
		_state = GunState.Idle
		if _fire_held:
			start_fire()
