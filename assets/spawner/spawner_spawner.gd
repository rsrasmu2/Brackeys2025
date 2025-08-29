extends Node3D

const SPAWNER_SCENE := preload("res://assets/spawner/spawner.tscn")

func activate() -> void:
	var spawner := SPAWNER_SCENE.instantiate()
	get_tree().root.add_child.call_deferred(spawner)
	spawner.global_transform = global_transform
	queue_free()

func remove() -> void:
	queue_free()
