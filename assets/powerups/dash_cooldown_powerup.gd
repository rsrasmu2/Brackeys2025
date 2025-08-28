extends Node

const NAME: String = "Dash Cooldown"
const DESCRIPTION: String = "Reduces your Dash cooldown by 10%."

@export var mult: float = 0.9

func apply(player: Player) -> void:
	player.get_node("Dash").cooldown *= mult
