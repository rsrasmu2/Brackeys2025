extends Node3D

@export var target: EnemyTarget
@export var controller: Enemy
@export var collision_damage: int = 15
@export var collision_knockback: float = 0.5
@export var hurtbox: Area3D

@export var y_min: float = 4.0
@export var y_max: float = 7.0

var target_position: Vector3
var speed: float = 10
var ground_speed: float = 0.2

@export var animation_player: AnimationPlayer

func _ready() -> void:
	set_process(false)

func _process(_delta: float) -> void:
	if controller.global_position == target.target.global_position:
		return
	controller.look_at(target.target.global_position, Vector3.UP, true)

func enter() -> void:
	set_process(true)
	animation_player.connect(animation_player.animation_finished.get_name(), _on_animation_finished)
	animation_player.play("walk")

func exit() -> void:
	set_process(false)
	animation_player.disconnect(animation_player.animation_finished.get_name(), _on_animation_finished)
	controller.target_velocity.x = 0
	controller.target_velocity.z = 0

func begin_walk() -> void:
	var displacement: Vector3 = target.target.global_position - global_position
	var velocity: Vector2 = Vector2(displacement.x, displacement.z).normalized() * speed
	controller.target_velocity.x = velocity.x
	controller.target_velocity.y = randf_range(y_min, y_max)
	controller.target_velocity.z = velocity.y

func end_walk() -> void:
	var displacement: Vector3 = target.target.global_position - global_position
	var velocity: Vector2 = Vector2(displacement.x, displacement.z).normalized() * ground_speed
	controller.target_velocity.x = velocity.x
	controller.target_velocity.z = velocity.y

func _on_animation_finished(_animation_name: String) -> void:
	controller.state = controller.EnemyState.Idle

func enable_damaging() -> void:
	hurtbox.connect("body_entered", _on_hurtbox_entered)
	hurtbox.monitoring = true
	await get_tree().physics_frame
	var bodies := hurtbox.get_overlapping_bodies()
	for body: Node3D in bodies:
		if body.has_method("take_damage"):
			var displacement := (body.global_position - global_position)
			displacement.y = 0.5
			var direction := displacement.normalized()
			body.take_damage(collision_damage, direction * collision_knockback, controller)
		hurtbox.monitoring = false
	
func disable_damaging() -> void:
	hurtbox.disconnect("body_entered", _on_hurtbox_entered)
	hurtbox.monitoring = false

func _on_hurtbox_entered(body: Node3D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(collision_damage, global_basis.z, controller)
