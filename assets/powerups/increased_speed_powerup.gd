extends Node

const NAME: String = "Movement Speed"
const DESCRIPTION: String = "You move 5% faster."

@export var speed_mult: float = 1.05

func apply(player: Player) -> void:
	player.get_node("PlayerMovement").speed *= speed_mult
