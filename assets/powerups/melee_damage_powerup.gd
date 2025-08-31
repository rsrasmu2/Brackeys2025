extends Node

const NAME: String = "Melee Damage"
const DESCRIPTION: String = "You deal 20% more melee damage."

@export var mult: float = 1.2

func apply(player: Player) -> void:
	player.get_node("PlayerMelee").damage *= mult
