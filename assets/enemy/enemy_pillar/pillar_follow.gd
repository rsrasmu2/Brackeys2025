extends Node3D

@export var controller: EnemyPillar
@export var target: EnemyTarget

@export var rotation_rate: float = -0.4

@export var facing_speed: float = 3

var end_forward: Vector3
var current_rotation: float = 0

var _facing: bool = false

func _ready() -> void:
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	if _facing:
		var target_pos: Vector3 = target.target.global_transform.origin
		target_pos.y = global_position.y
		var desired_x: Transform3D = global_transform.looking_at(target_pos, Vector3.UP)
		var from: Quaternion = global_transform.basis.get_rotation_quaternion()
		var to: Quaternion = desired_x.basis.get_rotation_quaternion()
		
		var angle := from.angle_to(to)
		if angle <= PI / 32.0:
			_facing = false
			controller.rotate_object_local(Vector3.RIGHT, current_rotation * delta)
			return
		
		var max_step := deg_to_rad(facing_speed) * delta
		var t: float = min(1.0, max_step / angle)
		var new: Quaternion = from.slerp(to, t)
		global_transform.basis = Basis(new)
	else:
		controller.rotate_object_local(Vector3.RIGHT, current_rotation * delta)

func _on_end_detected(_body: Node3D) -> void:
	$"../EndDetection".set_deferred("monitoring", false)
	$"../GroundDetection".set_deferred("monitoring", false)
	set_physics_process(false)
	
	$WaitTimer.start()
	await $WaitTimer.timeout
	
	controller.state = controller.EnemyState.Idle

func enter() -> void:
	_facing = true
	controller.look_at(target.target.global_position)
	set_physics_process(true)
	current_rotation = rotation_rate * 2 * PI
	end_forward = controller.basis.z
	$"../EndDetection".connect("body_entered", _on_end_detected)
	$"../EndDetection".monitoring = true
	

func exit() -> void:
	_facing = false
	set_physics_process(false)
	$"../EndDetection".monitoring = false
	$"../EndDetection".disconnect("body_entered", _on_end_detected)
	$"../GroundDetection".monitoring = true

func slerp_forward(weight: float, from: Vector3, to: Vector3) -> void:
	controller.look_at(controller.global_position + from.slerp(to, weight))
