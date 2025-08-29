extends Area3D

var _damage: int
var _speed: float
var _source: Node

func _physics_process(delta: float) -> void:
	global_position += -global_basis.z * (_speed * delta)

func init(speed: float, damage: int, source: Node) -> void:
	_speed = speed
	_damage = damage
	_source = source

func _on_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node3D) -> void:
	if body.has_method("take_damage"):
		if is_instance_valid(_source):
			body.take_damage(_damage, Vector3.ZERO, _source)
		else:
			body.take_damage(_damage, Vector3.ZERO, self)
	queue_free()
