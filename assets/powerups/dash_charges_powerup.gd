extends Node

const NAME: String = "Dash Charges"
const DESCRIPTION: String = "Your dash can be used an additional time."

func apply(player: Player) -> void:
	var dash: Dash = player.get_node("Dash")
	dash.max_charges += 1
	dash.remaining_charges += 1
