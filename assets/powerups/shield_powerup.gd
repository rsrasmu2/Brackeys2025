extends AnimatableBody3D

@export var speed_degrees: float = 2
@export var knockback: float = 5

func _physics_process(delta: float) -> void:
	rotate_y(speed_degrees * delta)

func take_damage(damage: int, knockback: Vector3, source: Node3D) -> void:
	if source.has_method("take_damage"):
		var displacement = global_position - source.global_position
		displacement.y = 0
		var direction = displacement.normalized()
		source.take_damage(0, direction * knockback, self)
