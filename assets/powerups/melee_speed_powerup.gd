extends Node

@export var speed_mult: float = 2.0

func apply(player: Player) -> void:
	player.get_node("PlayerCamera/Gun").melee_speed_mult *= speed_mult
	player.get_node("PlayerMelee").speed_mult *= speed_mult
