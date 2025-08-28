extends Node

const NAME: String = "Fire Rate"
const DESCRIPTION: String = "Your gun shoots 10% faster."

@export var mult: float = 0.9

func apply(player: Player) -> void:
	player.get_node("PlayerCamera/Gun").cooldown *= mult
