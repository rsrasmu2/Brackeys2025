extends Node3D

@export var spawn_data: Array[SpawnData]

const SPAWNER_SCENE := preload("res://assets/spawner/spawner.tscn")

func activate() -> Spawner:
	var spawner := SPAWNER_SCENE.instantiate()
	spawner.spawn_data = spawn_data
	get_tree().root.add_child.call_deferred(spawner)
	spawner.global_transform = global_transform
	queue_free()
	return spawner

func remove() -> void:
	queue_free()
