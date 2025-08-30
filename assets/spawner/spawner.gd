class_name Spawner
extends StaticBody3D

@export var spawn_data: Array[SpawnData]
@export var spawn_distance_min: float = 5.0
@export var spawn_distance_max: float = 15.0

@export var experience: int = 100

signal entered
signal exited
signal destroyed

const POWERUP_PICKUP_SCENE = preload("res://assets/powerups/powerup_pickup.tscn")

var _spawned: bool = false

var _player: Player:
	get():
		if _player == null:
			_player = get_tree().get_first_node_in_group("Player")
		return _player

func take_damage(amount: int, _knockback: Vector3, _source: Node) -> void:
	$Health.health -= amount

func _on_health_died() -> void:
	var powerup := POWERUP_PICKUP_SCENE.instantiate()
	get_tree().root.add_child(powerup)
	powerup.global_position = global_position
	emit_signal(destroyed.get_name())
	queue_free()

func _on_area_3d_body_entered(_body: Node3D) -> void:
	emit_signal(entered.get_name())
	$ForceField.visible = false
	$ForceField/StaticBody3D/CollisionShape3D.disabled = true
	if _spawned:
		return
	_spawned = true
	var to_spawn := spawn_data[randi() % spawn_data.size()]
	for enemy_scene: PackedScene in to_spawn.enemies:
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
			enemy.spawn()


func _on_area_3d_body_exited(_body: Node3D) -> void:
	emit_signal(exited.get_name())
	$ForceField.visible = true
	$ForceField/StaticBody3D/CollisionShape3D.disabled = false
