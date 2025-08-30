extends Node3D

@export var damage: int = 10
@export var radius: float = 15
@export var max_jumps: int = 3
@export var damage_falloff: float = 0.8

var current_damage: float = damage

func apply(bullet: Bullet) -> void:
	bullet.connect("hit", _on_hit.bind(bullet))

func _on_hit(body: Node3D, bullet: Bullet) -> void:
	var query_transform = bullet.transform
	var space := get_world_3d().direct_space_state
	var shape := SphereShape3D.new()
	shape.radius = radius
	var params := PhysicsShapeQueryParameters3D.new()
	params.shape = shape
	params.transform = query_transform
	params.collision_mask = 4
	var to_remove: Array[Node] = [body]
	for jump: int in range(max_jumps):
		var collisions := space.intersect_shape(params)
		for rem: Node in to_remove:
			collisions.erase(rem)
		if len(collisions) == 0:
			return
		var rand_index := randi() % collisions.size()
		var collision: Node3D = collisions[rand_index]["collider"]
		while collisions.size() > 0:
			if collision.has_method("take_damage"):
				collision.take_damage(current_damage, Vector3.ZERO, self)
				to_remove.push_back(collision)
				current_damage *= damage_falloff
				break
			collisions.remove_at(rand_index)
			rand_index = randi() % collisions.size()
			collision = collisions[rand_index]["collider"]
		break
