extends Node3D

@export var controller: EnemyPillar
@export var target: EnemyTarget

@export var rotation_rate: float = 120
@export var facing_speed: float = 60

var _facing: bool = false
@onready var _to_test: Node3D = $"../EndDetectionBottom"

func _ready() -> void:
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	if _facing:
		var up_angle: float = _to_test.global_basis.y.signed_angle_to(Vector3.DOWN, $"../MeshOrigin/Enemy_Pillar".basis.x)
		print(up_angle)
		if abs(up_angle) < 0.05:
			var target_pos: Vector3 = target.target.global_transform.origin
			target_pos.y = $"../MeshOrigin/Enemy_Pillar".global_position.y
			
			var desired_x: Transform3D = $"../MeshOrigin/Enemy_Pillar".global_transform.looking_at(target_pos, Vector3.UP)
			var from: Quaternion = $"../MeshOrigin/Enemy_Pillar".global_transform.basis.get_rotation_quaternion()
			var to: Quaternion = desired_x.basis.get_rotation_quaternion()
			
			var angle := from.angle_to(to) - PI
			if abs(angle) <= 0.05:
				$"../MeshOrigin/Enemy_Pillar".rotate_object_local(Vector3.UP, angle)
				_facing = false
				controller.rotate_object_local($"../MeshOrigin/Enemy_Pillar".basis.x, deg_to_rad(rotation_rate) * delta)
				return
			
			var max_step := deg_to_rad(facing_speed) * delta
			var t: float = min(1.0, max_step / angle)
			t = min(t, angle)
			$"../MeshOrigin/Enemy_Pillar".rotate_object_local(_to_test.global_basis.y, t)
		else:
			var speed: float = deg_to_rad(rotation_rate) * delta * sign(up_angle)
			if abs(up_angle) < abs(speed):
				speed = up_angle
			controller.rotate_object_local($"../MeshOrigin/Enemy_Pillar".basis.x, speed)
	else:
		controller.rotate_object_local($"../MeshOrigin/Enemy_Pillar".basis.x, deg_to_rad(rotation_rate) * delta)

func _on_end_top_detected(_body: Node3D) -> void:
	$"../EndDetectionTop".set_deferred("monitoring", false)
	$"../EndDetectionBottom".set_deferred("monitoring", true)
	_facing = true
	_to_test = $"../EndDetectionTop"

func _on_end_bottom_detected(_body: Node3D) -> void:
	$"../EndDetectionTop".set_deferred("monitoring", true)
	$"../EndDetectionBottom".set_deferred("monitoring", false)
	_facing = true
	_to_test = $"../EndDetectionBottom"

func enter() -> void:
	_facing = true
	set_physics_process(true)
	$"../EndDetectionTop".connect("body_entered", _on_end_top_detected)
	$"../EndDetectionBottom".connect("body_entered", _on_end_bottom_detected)
	$"../EndDetectionTop".monitoring = true
	$"../EndDetectionBottom".monitoring = true
	

func exit() -> void:
	_facing = false
	set_physics_process(false)
	$"../EndDetectionTop".monitoring = false
	$"../EndDetectionBottom".monitoring = false
	$"../EndDetectionTop".disconnect("body_entered", _on_end_top_detected)
	$"../EndDetectionBottom".disconnect("body_entered", _on_end_bottom_detected)
