extends Node

@export var amount: int = 6

func apply(player: Player) -> void:
	var gun: Gun = player.get_node("PlayerCamera/Gun")
	gun.max_ammo += amount
	gun.current_ammo += amount
