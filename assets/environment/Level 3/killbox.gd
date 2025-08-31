extends Area3D

@export var damage: int = 40

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.take_damage(damage, Vector3.ZERO, self)
		body.reset_position()
	else:
		body.queue_free()
