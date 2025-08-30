extends Node

const NAME: String = "Health Regeneration"
const DESCRIPTION: String = "You regenerate an additional 0.5 health per second."

@export var heal_amount: float = 0.5

func apply(player: Player) -> void:
	player.get_node("Health").regen += heal_amount
