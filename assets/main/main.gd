extends Node

@export var start_from_level: int = 0
@export var levels: Array[PackedScene]

var current_level: Level
@onready var current_level_index: int = self.start_from_level

func _ready() -> void:
	start_level(current_level_index)

func start_level(index: int) -> void:
	if current_level != null:
		current_level.queue_free()
	current_level = levels[index].instantiate()
	add_child(current_level)
	await current_level.ready
	var player_spawn := current_level.player_spawn
	get_tree().get_first_node_in_group("Player").global_transform = player_spawn.global_transform
	current_level.level_manager.connect("level_finished", _on_level_finished)

func _on_level_finished() -> void:
	current_level_index += 1
	if current_level_index < levels.size():
		start_level(current_level_index)
	else:
		$Label.visible = true
