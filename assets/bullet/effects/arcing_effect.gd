extends Node3D

@export var damage: int = 10
@export var radius: float = 15
@export var max_jumps: int = 3

func apply(bullet: Bullet) -> void:
	bullet.connect("hit", _on_hit.bind(bullet))

func _on_hit(body: Node3D, bullet: Bullet) -> void:
	var space := get_world_3d().direct_space_state
	var shape := SphereShape3D.new()
	shape.radius = radius
	var params := PhysicsShapeQueryParameters3D.new()
	params.shape = shape
	params.transform = bullet.transform
	params.collision_mask = 4
	var collisions := space.intersect_shape(params)
	for jump: int in range(max_jumps):
		if len(collisions) == 0:
			return
		var rand_index := randi() % collisions.size()
		var collision: Node3D = collisions[rand_index]["collider"]
		if collision == body:
			collisions.remove_at(rand_index)
			if collisions.size() == 0:
				return
			rand_index = randi() % collisions.size()
			collision = collisions[rand_index]["collider"]
		if collision.has_method("take_damage"):
			collision.take_damage(damage, Vector3.ZERO, self)
		collisions.remove_at(rand_index)
