extends Node

@export var speed_mult: float = 1.5

func apply(player: Player) -> void:
	player.get_node("PlayerMovement").speed *= speed_mult
