extends Node

func apply(player: Player) -> void:
	var dash: Dash = player.get_node("Dash")
	dash.max_charges += 1
	dash.remaining_charges += 1
