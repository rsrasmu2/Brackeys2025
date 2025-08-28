extends Node3D

@export var target: EnemyTarget
@export var controller: Enemy

var speed: float = 4

@export var animation_player: AnimationPlayer

func _ready() -> void:
	set_process(false)

func _process(_delta: float) -> void:
	var look_target := target.target.global_position
	look_target.y = global_position.y
	controller.look_at(look_target, Vector3.UP, true)
	$"../AngelModel".look_at(target.target.global_position)

func _physics_process(delta: float) -> void:
	var displacement: Vector3 = target.target.global_position - global_position
	var velocity: Vector2 = Vector2(displacement.x, displacement.z).normalized() * speed
	controller.target_velocity.x = velocity.x
	controller.target_velocity.z = velocity.y

func enter() -> void:
	set_process(true)
	animation_player.connect(animation_player.animation_finished.get_name(), _on_animation_finished)
	animation_player.play("walk")

func exit() -> void:
	set_process(false)
	animation_player.disconnect(animation_player.animation_finished.get_name(), _on_animation_finished)
	controller.target_velocity.x = 0
	controller.target_velocity.z = 0

func _on_animation_finished(_animation_name: String) -> void:
	controller.state = controller.EnemyState.Idle
