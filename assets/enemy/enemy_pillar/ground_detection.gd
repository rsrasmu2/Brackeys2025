extends Area3D

@export var controller: EnemyPillar

var grav: float = 0

func _physics_process(delta: float) -> void:
	if not monitoring:
		return
	if len(get_overlapping_bodies()) > 0:
		grav = 0
		var space := get_world_3d().direct_space_state
		var shape: Resource = $CollisionShape3D.shape
		var params := PhysicsShapeQueryParameters3D.new()
		params.set_shape(shape)
		params.transform = global_transform
		params.collide_with_bodies = true
		params.collision_mask = collision_mask
		
		var hits := space.collide_shape(params, 2)
		if hits.size() == 0:
			return
		var displacement: Vector3 = hits[0] - controller.global_position
		for node in controller.get_children():
			if not node is Node3D:
				continue
			node.global_position -= displacement
		var vertical_displacement := Vector3.UP * 0.1
		controller.global_position += displacement + vertical_displacement
		$"../MeshOrigin/Enemy_Pillar".global_position -= vertical_displacement
	else:
		grav -= 9.8 * delta
		controller.global_position += Vector3.UP * grav * delta
		$"../MeshOrigin/Enemy_Pillar".position = lerp($"../MeshOrigin/Enemy_Pillar".position, Vector3.UP * 3, delta)
		
