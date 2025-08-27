extends Area3D

@export var controller: Enemy
@export var target: EnemyTarget
@export var damage: int = 40
@export var knockback: float = 30
@export var rotation_rate: float = -0.6
@export var recovery_rate: float = 0.01

var current_rotation: float = 0
var end_basis: Basis

var _damage_dealt: bool = false

func enter() -> void:
	_damage_dealt = false
	monitoring = true
	controller.look_at(target.target.global_position)
	end_basis = controller.basis
	current_rotation = rotation_rate * 2 * PI
	$"../GroundDetection".connect("body_entered", _on_ground_detection_body_entered)
	$"../GroundDetection".monitoring = true
	set_physics_process(true)

func exit() -> void:
	monitoring = false
	$"../GroundDetection".disconnect("body_entered", _on_ground_detection_body_entered)
	$"../GroundDetection".monitoring = false
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	if len(get_overlapping_bodies()) > 0:
		controller.rotation.x += 0.1 * PI
		return
	controller.rotation.x += current_rotation * delta


func _on_ground_detection_body_entered(body: Node3D) -> void:
	monitoring = false
	set_physics_process(false)
	current_rotation = 0
	$"../GroundDetection".set_deferred("monitoring", false)
	$WaitTimer.start()
	await $WaitTimer.timeout
	var tween = create_tween()
	var start_basis = controller.basis
	tween.tween_method(tween_basis.bind(start_basis, end_basis), 0.0, 1.0, 2.0)
	await tween.finished
	$Timer.start()
	await $Timer.timeout
	controller.state = controller.EnemyState.Idle

func tween_basis(weight: float, start: Basis, end: Basis):
	controller.basis = start.slerp(end, weight)


func _on_body_entered(body: Node3D) -> void:
	if _damage_dealt:
		return
	if body.has_method("take_damage"):
		var displacement := (body.global_position - global_position)
		displacement.y = 0
		var direction := displacement.normalized()
		print(direction * knockback)
		body.take_damage(damage, direction * knockback)
		_damage_dealt = true
