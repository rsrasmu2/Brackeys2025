extends Area3D

var _speed: float

func _physics_process(delta: float) -> void:
	global_position += -global_basis.z * (_speed * delta)

func init(speed: float) -> void:
	_speed = speed
