extends Node

const NAME: String = "Reload Speed"
const DESCRIPTION: String = "You reload 5% faster."

@export var mult: float = 1.05

func apply(player: Player) -> void:
	player.get_node("PlayerCamera/Gun").reload_speed_mult *= mult
