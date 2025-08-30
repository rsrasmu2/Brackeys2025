
class_name LevelManager
extends Node3D

@export var spawns: Array[SpawnData]

@export var spawners_to_keep: int = 3

@export var spawn_distance_min: float = 8.0
@export var spawn_distance_max: float = 25.0

@export var spawn_timer_min: float = 8.0
@export var spawn_timer_max: float = 10.0
@export var spawn_timer_multiplier: float = 1.0

@export var teleporter: Teleporter
@export var bgm: BgmPlayer

@onready var _spawners_remaining: int = self.spawners_to_keep

var _level_finished: bool = false

signal level_finished

var _player: Player:
	get():
		if _player == null:
			_player = get_tree().get_first_node_in_group("Player")
		return _player

func _ready() -> void:
	set_process_input(false)
	teleporter.connect("teleporter_activated", _on_teleporter_activated)
	teleporter.connect("teleporter_completed", _on_teleporter_completed)
	start_level()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("activate"):
		_player.display_prompt("")
		bgm.fade_bgm()
		set_process_input(false)
		$LevelTransitionTimer.start()
		await $LevelTransitionTimer.timeout
		emit_signal(level_finished.get_name())

func start_level() -> void:
	var spawners := get_tree().get_nodes_in_group("SpawnerSpawners")
	for _i: int in range(spawners_to_keep):
		if spawners.size() == 0:
			return
		var index := randi() % spawners.size()
		var spawner_spawner := spawners[index]
		var spawner: Spawner = spawner_spawner.activate()
		spawner.connect("entered", _on_spawner_entered)
		spawner.connect("exited", _on_spawner_exited)
		spawner.connect("destroyed", _on_spawner_destroyed)
		spawners.remove_at(index)
	for spawner: Node in spawners:
		spawner.remove()

func start_spawn_timer() -> void:
	$SpawnTimer.wait_time = randf_range(spawn_timer_min, spawn_timer_max) * spawn_timer_multiplier
	$SpawnTimer.start()

func _on_spawn_timer_timeout() -> void:
	var enemies_to_spawn := spawns[randi() % len(spawns)]
	for enemy_to_spawn: Object in enemies_to_spawn.enemies:
		var enemy: Node3D = enemy_to_spawn.instantiate()
		get_tree().root.add_child(enemy)
		var distance := randf_range(spawn_distance_min, spawn_distance_max)
		var origin := _player.global_position + Vector3.FORWARD.rotated(Vector3.UP, randf() * 2.0 * PI) * distance
		origin.y += 50
		var space_state := get_world_3d().direct_space_state
		var end := origin + Vector3.DOWN * 100.0
		var query := PhysicsRayQueryParameters3D.create(origin, end)
		query.collide_with_bodies = true
		var result := space_state.intersect_ray(query)
		if not result.is_empty():
			enemy.global_position = result["position"] + Vector3.UP * 1.0
			enemy.look_at(_player.global_position, Vector3.UP, true)
			enemy.spawn()
	spawn_timer_multiplier = enemies_to_spawn.spawn_mult
	start_spawn_timer()

func _destroy_enemies() -> void:
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.drop_exp = false
		enemy.get_node("Health").health = 0

func _on_teleporter_activated() -> void:
	bgm.set_intensity(2)

func _on_teleporter_completed() -> void:
	bgm.set_intensity(0)
	$SpawnTimer.stop()
	_destroy_enemies()
	$LevelFinishDelay.start()
	await $LevelFinishDelay.timeout
	_level_finished = true
	_player.display_prompt("Press 'E' to continue")
	set_process_input(true)

func _on_spawner_destroyed() -> void:
	bgm.set_intensity(0)
	_spawners_remaining -= 1
	if _spawners_remaining == 0:
		teleporter.active = true

func _on_spawner_entered() -> void:
	bgm.set_intensity(1)
	
func _on_spawner_exited() -> void:
	bgm.set_intensity(0)
