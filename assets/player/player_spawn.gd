class_name PlayerSpawn
extends Node3D

const PLAYER_SCENE: Resource = preload("res://assets/player/player.tscn")

func _ready() -> void:
	await get_tree().root.ready
	var player: Player = get_tree().get_first_node_in_group("Player")
	if player == null:
		player = PLAYER_SCENE.instantiate()
		get_tree().root.add_child(player) # Adding to the root causes a crash, hopefully this will be okay
	player.global_position = global_position
	player.global_rotation = global_rotation
