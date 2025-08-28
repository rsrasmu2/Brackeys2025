extends Area3D

@export var controller: EnemyPillar
@export var target: EnemyTarget
@export var damage: int = 40
@export var knockback: float = 20
@export var rotation_rate: float = -0.8
@export var recovery_rate: float = 0.01

var current_rotation: float = 0
var end_forward: Vector3

var _damage_dealt: bool = false
var _returning: bool = false

func _ready() -> void:
	set_physics_process(false)

func enter() -> void:
	_returning = false
	_damage_dealt = false
	controller.look_at(target.target.global_position)
	monitoring = true
	end_forward = -controller.basis.z
	current_rotation = rotation_rate * 2 * PI
	$"../EndDetection".monitoring = true
	$"../EndDetection".connect("body_entered", _on_end_detected)
	set_physics_process(true)

func exit() -> void:
	monitoring = false
	$"../EndDetection".monitoring = false
	$"../EndDetection".disconnect("body_entered", _on_end_detected)
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	if _returning:
		return
	if len(get_overlapping_bodies()) > 1:
		controller.rotate(controller.basis.x, 0.1 * PI)
		return
	controller.rotate(controller.basis.x, current_rotation * delta)


func _on_end_detected(_body: Node3D) -> void:
	_returning = true
	$"../EndDetection".set_deferred("monitoring", false)
	set_deferred("monitoring", false)
	$WaitTimer.start()
	await $WaitTimer.timeout
	var tween := create_tween()
	var start_forward := -controller.basis.z
	tween.tween_method(slerp_forward.bind(start_forward, end_forward), 0.0, 1.0, 2.0)
	await tween.finished
	$Timer.start()
	await $Timer.timeout
	controller.state = controller.EnemyState.Idle

func slerp_forward(weight: float, from: Vector3, to: Vector3) -> void:
	controller.look_at(controller.global_position + from.slerp(to, weight))

func _on_body_entered(body: Node3D) -> void:
	if not body.has_method("take_damage"):
		return
		
	var displacement := (body.global_position - global_position)
	displacement.y = 0
	var direction := displacement.normalized()
	body.take_damage(0, direction * knockback, controller)
	
	if _damage_dealt:
		return
		
	if body.collision_layer == 2 and body.has_method("take_damage"):
		body.take_damage(damage, Vector3.ZERO, controller)
		_damage_dealt = true
