extends Node

const NAME: String = "Melee Speed"
const DESCRIPTION: String = "Increases the speed of your melee attacks by 15%."

@export var speed_mult: float = 1.15

func apply(player: Player) -> void:
	player.get_node("PlayerCamera/Gun").melee_speed_mult *= speed_mult
	player.get_node("PlayerMelee").speed_mult *= speed_mult
