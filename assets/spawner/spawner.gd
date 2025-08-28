extends StaticBody3D

@export var enemies: Array[PackedScene]
@export var spawn_distance_min: float = 5.0
@export var spawn_distance_max: float = 15.0

var _spawned: bool = false

var _player: Player:
	get():
		if _player == null:
			_player = get_tree().get_first_node_in_group("Player")
		return _player

func take_damage(amount: int, _knockback: Vector3, _source: Node3D) -> void:
	$Health.health -= amount

func _on_health_died() -> void:
	queue_free()

func _on_area_3d_body_entered(_body: Node3D) -> void:
	$ForceField.visible = false
	$ForceField/StaticBody3D/CollisionShape3D.disabled = true
	if _spawned:
		return
	_spawned = true
	for enemy_scene: PackedScene in enemies:
		var enemy := enemy_scene.instantiate()
		get_tree().root.add_child(enemy)
		var distance := randf_range(spawn_distance_min, spawn_distance_max)
		var origin := global_position + Vector3.FORWARD.rotated(Vector3.UP, randf() * 2.0 * PI) * distance
		origin.y += 50
		var space_state := get_world_3d().direct_space_state
		var end := origin + Vector3.DOWN * 100.0
		var query := PhysicsRayQueryParameters3D.create(origin, end)
		query.collide_with_bodies = true
		var result := space_state.intersect_ray(query)
		if not result.is_empty():
			enemy.global_position = result["position"]
			enemy.look_at(_player.global_position, Vector3.UP, true)


func _on_area_3d_body_exited(_body: Node3D) -> void:
	$ForceField.visible = true
	$ForceField/StaticBody3D/CollisionShape3D.disabled = false
