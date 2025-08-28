extends Node

const NAME: String = "Magazine Size"
const DESCRIPTION: String = "Increases your magazine size by 4."

@export var amount: int = 4

func apply(player: Player) -> void:
	var gun: Gun = player.get_node("PlayerCamera/Gun")
	gun.max_ammo += amount
	gun.current_ammo += amount
