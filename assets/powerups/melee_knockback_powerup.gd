extends Node

const NAME: String = "Melee Knockback"
const DESCRIPTION: String = "Increases your melee knockback range by 30%."

@export var mult: float = 1.3

func apply(player: Player) -> void:
	player.get_node("PlayerMelee").knockback *= mult
