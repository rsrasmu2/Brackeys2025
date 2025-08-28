extends Node

const NAME: String = "Pickup Range"
const DESCRIPTION: String = "Increases your pickup range by 20%."

@export var mult: float = 1.2

func apply(player: Player) -> void:
	player.get_node("OrbPickup").range *= mult
