extends Node3D

@export var controller: Enemy
@export var target: EnemyTarget

@export var collision_damage: float = 15
@export var collision_knockback: float = 30

@export var rotation_rate: float = -0.4

@export var distance_to_follow: float = 50.0
var _sqr_follow_distance: float = distance_to_follow * distance_to_follow

@export var distance_to_attack: float = 7.0
var _sqr_attack_distance: float = distance_to_attack * distance_to_attack

var current_rotation: float = 0
var end_basis: Basis

func _physics_process(delta: float) -> void:
	if len($"../PillarAttack".get_overlapping_bodies()) > 0:
		controller.rotation.x += 0.1 * PI
		return
	controller.rotation.x += current_rotation * delta


func _on_ground_detection_body_entered(body: Node3D) -> void:
	set_physics_process(false)
	$"../GroundDetection".set_deferred("monitoring", false)
	$WaitTimer.start()
	await $WaitTimer.timeout
	controller.rotation.y += PI
	controller.position += -controller.transform.basis.y * 6
	if controller.is_on_floor():
		controller.global_position.y += 0.1
	var start_basis = controller.basis
	var tween = create_tween()
	tween.tween_method(tween_basis.bind(start_basis, end_basis), 0.0, 1.0, 1.0)
	await tween.finished
	controller.rotate_y(PI)
	$WaitTimer.start()
	await $WaitTimer.timeout
	controller.state = controller.EnemyState.Idle

func tween_basis(weight: float, start: Basis, end: Basis):
	controller.basis = start.slerp(end, weight)

func enter() -> void:
	controller.look_at(target.target.global_position)
	set_process(true)
	set_physics_process(true)
	current_rotation = rotation_rate * 2 * PI
	end_basis = controller.basis.rotated(Vector3.UP, PI)
	$"../GroundDetection".connect("body_entered", _on_ground_detection_body_entered)
	$"../GroundDetection".monitoring = true
	

func exit() -> void:
	set_process(false)
	set_physics_process(false)
	$"../GroundDetection".monitoring = false
	$"../GroundDetection".disconnect("body_entered", _on_ground_detection_body_entered)
