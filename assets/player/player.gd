class_name Player
extends CharacterBody3D

const ACCELERATION: float = 20.0
const STOP_FORCE: float = 40.0
const FIRING_MULT: float = 0.7

const GRAVITY: float = 9.8

var gravity_enabled: bool = false

var current_dash_speed: float = 0:
	set(value):
		if current_dash_speed != value:
			current_dash_speed = value

var is_dashing: bool:
	get():
		return current_dash_speed != 0

var _delta: float = 0
var _target_velocity: Vector2
var _in_air: bool = false:
	set(value):
		if _in_air == value:
			return
		_in_air = value
		if _in_air:
			_last_ground = global_position
			_last_ground.y += 1
			_last_grounded_velocity = velocity
var _is_firing: bool = false

var gravity_effect: float = 0
var knockback: Vector3 = Vector3.ZERO

var _last_ground: Vector3
var _last_grounded_velocity: Vector3

@onready var timer_label: Label = $PlayerCamera/UI/TimerLabel

func _process(delta: float) -> void:
	_delta = delta
	var target_position: Vector3 = Vector3.ZERO # I hate that this can't be null
	if $PlayerCamera/RayCast3D.is_colliding():
		target_position = $PlayerCamera/RayCast3D.get_collision_point()
	else:
		target_position = $PlayerCamera/RayCast3D.global_position + $PlayerCamera/RayCast3D.global_basis.z * 100
	$PlayerCamera/Gun.set_aim_target(target_position)

func _physics_process(delta: float) -> void:
	# Apply gravity
	if !is_on_floor():
		_in_air = true
		if gravity_enabled:
			if not is_dashing:
				gravity_effect = GRAVITY
			else:
				gravity_effect = 0
				velocity.y = 0
		else:
			gravity_effect = 0
			velocity.y = 0
	elif _in_air && is_on_floor():
		_in_air = false
		gravity_effect = 0
		velocity.y = 0
		if not $PlayerJump/LandAudio.playing:
			$PlayerJump/LandAudio.play_pitched()
	
	velocity.x = _target_velocity.x * (1 + current_dash_speed)
	velocity.y -= gravity_effect * delta
	velocity.z = _target_velocity.y * (1 + current_dash_speed)
	velocity += knockback
	
	move_and_slide()

func add_powerup(powerup: Node) -> void:
	$Powerups.add_child(powerup)
	if powerup.has_method("apply"):
		powerup.apply(self)

func set_horizontal_velocity(direction: Vector2) -> void:
	_target_velocity = direction
	if _is_firing:
		_target_velocity *= FIRING_MULT

func _on_gun_firing_changed(is_firing: bool) -> void:
	_is_firing = is_firing

func take_damage(amount: int, knockback_amount: Vector3, _source: Node) -> void:
	$Health.health -= amount
	$Knockback.add_knockback(knockback_amount)

func add_status_effect(effect: Node) -> void:
	$StatusEffects.add_child(effect)
	effect.apply(self)

func _on_health_died() -> void:
	$CollisionShape3D.disabled = true
	set_process(false)
	set_physics_process(false)

func _on_experience_level_up(_level: int) -> void:
	var powerups: Array[PackedScene] = []
	var indices: Array[int] = []
	for i: int in range(3):
		var index: int = randi() % $Experience.level_up_powerups.size()
		while indices.has(index):
			index = randi() % $Experience.level_up_powerups.size()
		powerups.push_back($Experience.level_up_powerups[index])
		indices.push_back(index)
	select_powerup(powerups, "Level Up")

func select_powerup(powerups: Array[PackedScene], label_text: String) -> void:
	$PlayerCamera/Gun.reset_firing()
	get_tree().paused = true
	$PlayerCamera/UI/PowerupSelectionPanel.show_powerups(powerups, label_text)

func display_prompt(text: String) -> void:
	$PlayerCamera/UI/TeleporterPrompt.text = text

func reset_position() -> void:
	var displacement = -_last_grounded_velocity * 0.05
	displacement.y = 0
	global_position = _last_ground + displacement
	global_position.y += 0.5
	velocity.y = 0
