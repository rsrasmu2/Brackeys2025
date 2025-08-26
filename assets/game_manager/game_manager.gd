class_name GameManager
extends Node3D

@export var spawns: Array[Dictionary]

@export var spawn_distance_min: float = 8.0
@export var spawn_distance_max: float = 25.0

@export var spawn_timer_min: float = 8.0
@export var spawn_timer_max: float = 10.0
@export var spawn_timer_multiplier: float = 1.0

var _player: Player:
	get():
		if _player == null:
			_player = get_tree().get_first_node_in_group("Player")
		return _player

func start_spawn_timer() -> void:
	$SpawnTimer.wait_time = randf_range(spawn_timer_min, spawn_timer_max) * spawn_timer_multiplier
	$SpawnTimer.start()


func _on_spawn_timer_timeout() -> void:
	var enemies_to_spawn: Dictionary = spawns[randi() % len(spawns)]
	for enemy_to_spawn: Resource in enemies_to_spawn["enemies"]:
		var enemy: Enemy = enemy_to_spawn.instantiate()
		get_tree().root.add_child(enemy)
		var range = randf_range(spawn_distance_min, spawn_distance_max)
		var origin = _player.global_position + Vector3.FORWARD.rotated(Vector3.UP, randf() * 2.0 * PI) * range
		origin.y += 50
		var space_state = get_world_3d().direct_space_state
		var end = origin + Vector3.DOWN * 100.0
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		query.collide_with_bodies = true
		var result = space_state.intersect_ray(query)
		if not result.is_empty():
			enemy.global_position = result["position"]
			enemy.look_at(_player.global_position, Vector3.UP, true)
	spawn_timer_multiplier = enemies_to_spawn["spawn_mult"]
	start_spawn_timer()
