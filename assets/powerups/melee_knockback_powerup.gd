extends Node

const NAME: String = "Melee Knockback"
const DESCRIPTION: String = "Increases your melee knockback range by 20%."

@export var mult: float = 1.2

func apply(player: Player) -> void:
	player.get_node("PlayerMelee").knockback *= mult
