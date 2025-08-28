extends Node

const NAME: String = "Dash Speed"
const DESCRIPTION: String = "Increases your dash speed by 20%."

@export var mult: float = 1.2

func apply(player: Player) -> void:
	player.get_node("Dash").dash_speed *= mult
