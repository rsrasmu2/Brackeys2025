extends Node

@export var start_from_level: int = 0
@export var levels: Array[PackedScene]

var current_level: Level
var current_level_index: int

const PLAYER_SCENE := preload("res://assets/player/player.tscn")

var _player: Player

func _ready() -> void:
	current_level_index = start_from_level
	await get_tree().root.ready
	_player = PLAYER_SCENE.instantiate()
	get_tree().root.add_child(_player)
	start_level(current_level_index)

func start_level(index: int) -> void:
	if current_level != null:
		current_level.queue_free()
	current_level = levels[index].instantiate()
	current_level.connect("loaded", _on_level_loaded)
	add_child(current_level)

func _on_level_loaded() -> void:
	current_level.level_manager.connect("level_finished", _on_level_finished)
	_player.global_transform = current_level.player_spawn.global_transform

func _on_level_finished() -> void:
	current_level_index += 1
	if current_level_index < levels.size():
		start_level(current_level_index)
	else:
		$Label.visible = true
