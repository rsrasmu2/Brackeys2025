extends Area3D

@export var damage: int = 40

func _on_body_entered(body: Node3D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage, Vector3.ZERO, self)
	if body.has_method("reset_position"):
		body.reset_position()
