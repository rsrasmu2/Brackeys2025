extends Node

@export var mult: float = 3.0

func apply(player: Player) -> void:
	player.get_node("PlayerMelee").knockback *= mult
