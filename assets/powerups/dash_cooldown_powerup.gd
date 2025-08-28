extends Node

@export var mult: float = 0.5

func apply(player: Player) -> void:
	player.get_node("Dash").cooldown *= mult
