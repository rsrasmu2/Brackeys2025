extends Node

const NAME: String = "Health Regeneration"
const DESCRIPTION: String = "You regenerate an additional 2 health per second."

@export var heal_amount: int = 2

func apply(player: Player) -> void:
	player.get_node("Health").regen += heal_amount
