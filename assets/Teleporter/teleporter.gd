class_name Teleporter
extends StaticBody3D

@export var spawn_data: Array[SpawnData]
@export var spawn_distance_min: float = 5.0
@export var spawn_distance_max: float = 15.0

@export var experience: int = 100
@export var wave_cooldown: float = 15
@export var wave_cooldown_mult: float = 0.9

signal teleporter_activated
signal teleporter_completed

var active: bool = false:
	set(value):
		active = value
		$Area3D.monitoring = active
		$Beacons.visible = active
		set_process_input(active)

var _began: bool = false
var _activatable: bool = false

var _finished: bool = false

var _player: Player:
	get():
		if _player == null:
			_player = get_tree().get_first_node_in_group("Player")
		return _player

func _ready() -> void:
	active = false
	set_process(false)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("activate"):
		if _activatable:
			_begin()
			$Area3D.monitoring = false
			_activatable = false
			_player.display_prompt("")
			$Beacons.queue_free()
			emit_signal(teleporter_activated.get_name())
		elif _finished:
			emit_signal(teleporter_completed.get_name())
		

func _process(_delta: float) -> void:
	_player.timer_label.text = str(ceil($Timer.time_left))

func _begin() -> void:
	_began = true
	_spawn_enemies()
	$WaveCooldown.wait_time = wave_cooldown
	$WaveCooldown.start()
	$Timer.start()
	set_process(true)

func _on_area_3d_body_entered(_body: Node3D) -> void:
	if _began:
		return
	_activatable = true
	_player.display_prompt("Press 'E' to activate the teleporter")

func _spawn_enemies() -> void:
	var to_spawn := spawn_data[randi() % spawn_data.size()]
	for enemy_scene: PackedScene in to_spawn.enemies:
		var enemy := enemy_scene.instantiate()
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
			enemy.global_position = result["position"]
			enemy.look_at(_player.global_position, Vector3.UP, true)
			enemy.spawn()


func _on_wave_cooldown_timeout() -> void:
	_spawn_enemies()
	$WaveCooldown.wait_time *= wave_cooldown_mult
	$WaveCooldown.start()


func _on_timer_timeout() -> void:
	set_process(false)
	emit_signal(teleporter_completed.get_name())
	$WaveCooldown.stop()
	_player.timer_label.text = ""

func _on_area_3d_body_exited(_body: Node3D) -> void:
	_activatable = false
	_player.display_prompt("")
