extends Node3D

@export var controller: EnemyPillar
@export var target: EnemyTarget

@export var rotation_rate: float = 200
@export var facing_speed: float = 180

var _facing: bool = false
@onready var _to_test: Node3D = $"../MeshOrigin/Enemy_Pillar/EndDetectionBottom"
@onready var _mesh: Node3D = $"../MeshOrigin/Enemy_Pillar"

@onready var _top: Area3D = $"../MeshOrigin/Enemy_Pillar/EndDetectionTop"
@onready var _bottom: Area3D = $"../MeshOrigin/Enemy_Pillar/EndDetectionBottom"

@onready var _audio: PitchRandomizer3D = $AudioStreamPlayer3D

var _detections: int = 0
var next_position: Vector3

func _ready() -> void:
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	if _facing:
		var up_angle: float = _to_test.global_basis.y.signed_angle_to(Vector3.UP, _to_test.global_basis.x)
		if abs(up_angle) < 0.05:
			var displacement := next_position - _to_test.global_position
			displacement.y = 0
			var direction := displacement.normalized()
			var angle: float = (-_to_test.global_basis.z).signed_angle_to(direction, _to_test.global_basis.y)
			var abs_angle: float= abs(angle)
			var max_step := deg_to_rad(facing_speed) * delta
			var t: float = min(1.0, max_step / abs_angle)
			t = min(t, abs_angle) * sign(angle)
			if abs_angle <= abs(t):
				_mesh.rotate_object_local(_to_test.basis.y, angle)
				_facing = false
				if _detections > 1:
					controller.state = controller.EnemyState.Idle
				return
			_mesh.rotate_object_local(_to_test.basis.y, t)
		else:
			var speed: float = deg_to_rad(rotation_rate) * delta
			if abs(up_angle) < abs(speed):
				speed = up_angle
			controller.rotate_object_local(-_mesh.basis.x, speed)
	else:
		controller.rotate_object_local(-_mesh.basis.x, deg_to_rad(rotation_rate) * delta)

func _on_end_top_detected(_body: Node3D) -> void:
	$"../NavigationAgent3D".target_position = target.target.global_position
	next_position = $"../NavigationAgent3D".get_next_path_position()
	_detections += 1
	_top.set_deferred("monitoring", false)
	_bottom.set_deferred("monitoring", true)
	_facing = true
	_to_test = _top
	if not _audio.playing:
		_audio.play_pitched()

func _on_end_bottom_detected(_body: Node3D) -> void:
	$"../NavigationAgent3D".target_position = target.target.global_position
	next_position = $"../NavigationAgent3D".get_next_path_position()
	_detections += 1
	_top.set_deferred("monitoring", true)
	_bottom.set_deferred("monitoring", false)
	_facing = true
	_to_test = _bottom
	if not _audio.playing:
		_audio.play_pitched()

func enter() -> void:
	$"../NavigationAgent3D".target_position = target.target.global_position
	next_position = $"../NavigationAgent3D".get_next_path_position()
	_detections = 0
	_facing = true
	set_physics_process(true)
	_top.connect("body_entered", _on_end_top_detected)
	_bottom.connect("body_entered", _on_end_bottom_detected)
	_top.monitoring = true
	_bottom.monitoring = true
	

func exit() -> void:
	_facing = false
	set_physics_process(false)
	_top.monitoring = false
	_bottom.monitoring = false
	_top.disconnect("body_entered", _on_end_top_detected)
	_bottom.disconnect("body_entered", _on_end_bottom_detected)
