extends AnimatableBody3D

@export var speed_degrees: float = 2
@export var retaliatory_knockback: float = 5

func _physics_process(delta: float) -> void:
	rotate_y(speed_degrees * delta)

func take_damage(_damage: int, _knockback: Vector3, source: Node) -> void:
	if source.has_method("take_damage"):
		var displacement: Vector3 = global_position - source.global_position
		displacement.y = 0
		var direction := displacement.normalized()
		source.take_damage(0, direction * retaliatory_knockback, self)
