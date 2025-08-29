extends Area3D

@export var controller: EnemyPillar

func _physics_process(_delta: float) -> void:
	if not monitoring:
		return
	if len(get_overlapping_bodies()) > 0:
		var space := get_world_3d().direct_space_state
		var shape: Resource = $CollisionShape3D.shape
		var params := PhysicsShapeQueryParameters3D.new()
		params.set_shape(shape)
		params.transform = global_transform
		params.collide_with_bodies = true
		params.collision_mask = collision_mask
		
		var hits := space.intersect_shape(params, 1)
		for hit in hits:
			var world_pos: Vector3 = hit["position"]
			var local_pos = to_local(world_pos)
			for node in controller.get_children():
				if not node is Node3D:
					continue
				node.position -= local_pos
