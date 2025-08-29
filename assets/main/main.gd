extends Node

@export var start_from_level: int = 0
@export var levels: Array[PackedScene]

var current_level: Level
@onready var current_level_index: int = self.start_from_level

var _player: Player:
	get():
		if _player == null:
			_player = get_tree().get_first_node_in_group("Player")
		return _player

func _ready() -> void:
	start_level(current_level_index)

func start_level(index: int) -> void:
	if current_level != null:
		current_level.queue_free()
	current_level = levels[index].instantiate()
	current_level.connect("loaded", _on_level_loaded)
	add_child(current_level)
	print("Hmmmm")

func _on_level_loaded() -> void:
	print("Loaded")
	current_level.level_manager.connect("level_finished", _on_level_finished)
	print("CurrentLevel Connected")
	print(str(current_level.level_manager.level_finished.get_connections()))

func _on_level_finished() -> void:
	print("????")
	current_level_index += 1
	if current_level_index < levels.size():
		start_level(current_level_index)
	else:
		$Label.visible = true
