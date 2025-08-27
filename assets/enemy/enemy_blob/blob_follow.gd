extends Node3D

@export var target: EnemyTarget
@export var controller: Enemy
@export var collision_damage: int = 15
@export var hurtbox: Area3D

const WALK_VELOCITY_Y = 3.0

var target_position: Vector3
var speed: float = 4
var ground_speed: float = 0.5

@export var animation_player: AnimationPlayer

func _ready() -> void:
	set_process(false)

func _process(_delta: float) -> void:
	controller.look_at(target.target.global_position, Vector3.UP, true)

func enter() -> void:
	set_process(true)
	animation_player.connect(animation_player.animation_finished.get_name(), _on_animation_finished)
	animation_player.play("walk")

func exit() -> void:
	set_process(false)
	animation_player.disconnect(animation_player.animation_finished.get_name(), _on_animation_finished)
	controller.velocity.x = 0
	controller.velocity.z = 0

func begin_walk() -> void:
	var displacement: Vector3 = target.target.global_position - global_position
	var velocity: Vector2 = Vector2(displacement.x, displacement.z).normalized() * speed
	controller.velocity.x = velocity.x
	controller.velocity.y = WALK_VELOCITY_Y
	controller.velocity.z = velocity.y

func end_walk() -> void:
	var displacement: Vector3 = target.target.global_position - global_position
	var velocity: Vector2 = Vector2(displacement.x, displacement.z).normalized() * ground_speed
	controller.velocity.x = velocity.x
	controller.velocity.z = velocity.y

func _on_animation_finished(_animation_name: String) -> void:
	controller.state = controller.EnemyState.Idle

func enable_damaging() -> void:
	hurtbox.connect("body_entered", _on_hurtbox_entered)
	hurtbox.monitoring = true
	await get_tree().physics_frame
	var bodies = hurtbox.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("take_damage"):
			body.take_damage(collision_damage)
		hurtbox.monitoring = false
	
func disable_damaging() -> void:
	hurtbox.disconnect("body_entered", _on_hurtbox_entered)
	hurtbox.monitoring = false

func _on_hurtbox_entered(body: Node3D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(collision_damage)
