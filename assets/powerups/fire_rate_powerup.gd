extends Node

@export var mult: float = 0.4

func apply(player: Player) -> void:
	player.get_node("PlayerCamera/Gun").cooldown *= mult
