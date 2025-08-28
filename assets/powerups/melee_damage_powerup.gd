extends Node

@export var mult: float = 2.0

func apply(player: Player) -> void:
	player.get_node("PlayerMelee").damage *= mult
