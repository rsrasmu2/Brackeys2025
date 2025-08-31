extends Node3D

@export var damage: int = 5
@export var radius: float = 3

func apply(bullet: Bullet) -> void:
	bullet.connect("hit", _on_hit.bind(bullet))

func _on_hit(_body: Node3D, bullet: Bullet) -> void:
	var space := get_world_3d().direct_space_state
	var shape := SphereShape3D.new()
	shape.radius = radius
	var params := PhysicsShapeQueryParameters3D.new()
	params.shape = shape
	params.transform = bullet.transform
	params.collision_mask = 4
	var collisions := space.intersect_shape(params)
	for collision: Dictionary in collisions:
		var other: Node3D = collision["collider"]
		if other.has_method("take_damage"):
			other.take_damage(damage, Vector3.ZERO, self)
