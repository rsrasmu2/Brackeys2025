class_name PowerupPickup
extends Area3D

@export var powerups: Array[PackedScene]

func pickup(player: Player) -> void:
	var to_pick: Array[PackedScene] = []
	var indices: Array[int] = []
	for i: int in range(3):
		var index: int = randi() % powerups.size()
		while indices.has(index):
			index = randi() % powerups.size()
		to_pick.push_back(powerups[index])
		indices.push_back(index)
	player.select_powerup(to_pick, "Choose a Power")
	queue_free()
