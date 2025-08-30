extends Node

const NAME: String = "Dash Distance"
const DESCRIPTION: String = "Increases your dash distance by 20%."

@export var mult: float = 1.2

func apply(player: Player) -> void:
	player.get_node("Dash").dash_speed *= mult
