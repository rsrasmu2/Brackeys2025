extends Area3D

@export var controller: EnemyPillar
@export var target: EnemyTarget
@export var damage: int = 40
@export var knockback: float = 20
@export var rotation_rate: float = 360
@export var recovery_rate: float = 80
@export var facing_speed: float = 180

var _return_angle: float = 0

var _damage_dealt: bool = false
var _returning: bool = false
var _starting_sign: float = 0

@onready var _mesh: Node3D = $"../MeshOrigin/Enemy_Pillar"
@onready var _smash_area: Area3D = $"../MeshOrigin/Enemy_Pillar/SmashTopPosition/SmashDetection"
var _bottom: Area3D

func _ready() -> void:
	set_physics_process(false)

func enter() -> void:
	if $"../MeshOrigin/Enemy_Pillar/EndDetectionTop".global_position.y > $"../MeshOrigin/Enemy_Pillar/EndDetectionBottom".global_position.y:
		_bottom = $"../MeshOrigin/Enemy_Pillar/EndDetectionBottom"
		_smash_area.reparent($"../MeshOrigin/Enemy_Pillar/SmashTopPosition", false)
	else:
		_bottom = $"../MeshOrigin/Enemy_Pillar/EndDetectionTop"
		_smash_area.reparent($"../MeshOrigin/Enemy_Pillar/SmashBottomPosition", false)
	_returning = false
	_damage_dealt = false
	_return_angle = 0
	monitoring = true
	_smash_area.monitoring = true
	_smash_area.connect("body_entered", _on_end_detected)
	set_physics_process(true)

func exit() -> void:
	monitoring = false
	_smash_area.monitoring = false
	_smash_area.disconnect("body_entered", _on_end_detected)
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	if _returning:
		var up_angle: float = _bottom.global_basis.y.signed_angle_to(Vector3.UP, _bottom.global_basis.x)
		var speed: float = deg_to_rad(recovery_rate) * delta * sign(up_angle)
		if sign(up_angle) != _starting_sign:
			controller.state = controller.EnemyState.Idle
			return
		if abs(up_angle) < abs(speed):
			speed = up_angle
		controller.rotate_object_local(_mesh.basis.x, speed)
		if abs(up_angle) <= abs(speed):
			controller.state = controller.EnemyState.Idle
		return
	if len(get_overlapping_bodies()) > 1:
		var angle_a := deg_to_rad(rotation_rate * 2) * delta
		controller.rotate_object_local(_mesh.basis.x, angle_a)
		return
	var angle := deg_to_rad(rotation_rate) * delta
	controller.rotate_object_local(-_mesh.basis.x, angle)
	_return_angle -= angle


func _on_end_detected(_body: Node3D) -> void:
	_starting_sign = sign(_bottom.global_basis.y.signed_angle_to(Vector3.UP, _bottom.global_basis.x))
	_smash_area.set_deferred("monitoring", false)
	set_deferred("monitoring", false)
	$WaitTimer.start()
	_returning = true
	$AudioStreamPlayer3D.play_pitched()

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
