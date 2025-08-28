extends Node

@export var mult = 5.0

func apply(bullet: Bullet) -> void:
	bullet.get_node("MeshInstance3D").scale *= mult
	var collision = bullet.get_node("Area3D/CollisionShape3D")
	var new_shape = SphereShape3D.new()
	new_shape.radius = collision.shape.radius * mult
	collision.shape = new_shape
