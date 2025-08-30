class_name Level
extends Node3D

@export var level_manager: LevelManager
@export var player_spawn: PlayerSpawn

signal loaded

func _ready() -> void:
	await get_tree().process_frame
	emit_signal(loaded.get_name())
