extends Node3D

@export var controller: Enemy
@export var target: EnemyTarget

@export var rotation_rate: float = -0.4

var end_forward: Vector3
var current_rotation: float = 0

var _target_forward: Vector3

func _ready() -> void:
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	controller.rotate(controller.basis.x, current_rotation * delta)

func _on_end_detected(body: Node3D) -> void:
	$"../EndDetection".set_deferred("monitoring", false)
	set_physics_process(false)
	$WaitTimer.start()
	await $WaitTimer.timeout
	controller.global_position += controller.basis.y * 6
	controller.rotate(controller.basis.z, PI)
	var start_forward = -controller.basis.z
	var tween = create_tween()
	tween.tween_method(slerp_forward.bind(start_forward, end_forward), 0.0, 1.0, 1.0)
	await tween.finished
	controller.rotate_y(PI)
	$WaitTimer.start()
	await $WaitTimer.timeout
	controller.state = controller.EnemyState.Idle

func enter() -> void:
	controller.gravity_enabled = false
	controller.look_at(target.target.global_position)
	set_physics_process(true)
	current_rotation = rotation_rate * 2 * PI
	end_forward = controller.basis.z
	$"../EndDetection".connect("body_entered", _on_end_detected)
	$"../EndDetection".monitoring = true
	

func exit() -> void:
	controller.gravity_enabled = true
	set_physics_process(false)
	$"../EndDetection".monitoring = false
	$"../EndDetection".disconnect("body_entered", _on_end_detected)

func slerp_forward(weight: float, from: Vector3, to: Vector3) -> void:
	controller.look_at(controller.global_position + from.slerp(to, weight))
