extends Node3D

@export var start_from_level: int = 0
@export var levels: Array[PackedScene]

var current_level: Level
var current_level_index: int

var _player: Player

func _ready() -> void:
	current_level_index = start_from_level
	_player = load("res://assets/player/player.tscn").instantiate()
	add_child(_player)
	load_level(current_level_index)

func load_level(index: int) -> void:
	if current_level != null:
		current_level.queue_free()
	current_level = levels[index].instantiate()
	add_child(current_level)
	current_level.level_manager.connect("level_finished", _on_level_finished)
	_player.global_position = current_level.player_spawn.global_position
	_player.global_rotation = current_level.player_spawn.global_rotation
	_player.gravity_enabled = true

func _on_level_finished() -> void:
	_player.gravity_enabled = false
	current_level_index += 1
	if current_level_index < levels.size():
		load_level(current_level_index)
	else:
		$Label.visible = true
