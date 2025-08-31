extends Node

const NAME: String = "Reload Speed"
const DESCRIPTION: String = "You reload 15% faster."

@export var mult: float = 1.15

func apply(player: Player) -> void:
	player.get_node("PlayerCamera/Gun").reload_speed_mult *= mult
