extends Node

func apply(player: Player) -> void:
	player.get_node("PlayerJump").extra_jumps += 1
