extends Node

const NAME: String = "Extra Jump"
const DESCRIPTION: String = "Allows you to jump an additional time while in the air."

func apply(player: Player) -> void:
	player.get_node("PlayerJump").extra_jumps += 1
