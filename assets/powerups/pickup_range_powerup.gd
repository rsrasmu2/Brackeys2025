extends Node

const NAME: String = "Pickup Range"
const DESCRIPTION: String = "Increases your pickup range by 40%."

@export var mult: float = 1.4

func apply(player: Player) -> void:
	player.get_node("OrbPickup").pickup_range *= mult
