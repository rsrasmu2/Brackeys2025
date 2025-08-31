extends Node3D

@export var damage: int = 10
@export var radius: float = 10
@export var max_jumps: int = 3
@export var damage_falloff: float = 0.8

const ARC_SCENE := preload("res://assets/common/chain/chain.tscn")

var current_damage: float = damage

func apply(bullet: Bullet) -> void:
	bullet.connect("hit", _on_hit.bind(bullet))

func _on_hit(body: Node3D, bullet: Bullet) -> void:
	var previous_position := body.global_position
	var query_transform := bullet.transform
	var space := get_world_3d().direct_space_state
	var shape := SphereShape3D.new()
	shape.radius = radius
	var params := PhysicsShapeQueryParameters3D.new()
	params.shape = shape
	params.transform = query_transform
	params.collision_mask = 4
	for jump: int in range(max_jumps):
		var collisions := space.intersect_shape(params)
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
		while collisions.size() > 0:
			if collision.has_method("take_damage"):
				collision.take_damage(current_damage, Vector3.ZERO, self)
				params.exclude.push_back(collisions[rand_index]["rid"])
				current_damage *= damage_falloff
				if previous_position != Vector3.ZERO and previous_position.distance_squared_to(collision.global_position) > 0.2:
					var arc := ARC_SCENE.instantiate()
					get_tree().root.add_child(arc)
					arc.init(previous_position, collision.global_position)
				previous_position = collision.global_position
				break
			collisions.remove_at(rand_index)
			rand_index = randi() % collisions.size()
			collision = collisions[rand_index]["collider"]

func _remove_node(collision: Dictionary, to_remove: Node) -> bool:
	return collision["collider"] == to_remove
