extends Node

const NAME: String = "Bullet Damage"
const DESCRIPTION: String = "Your bullets deal 10% more damage."

@export var mult: float = 1.1

func apply(player: Player) -> void:
	player.get_node("PlayerCamera/Gun").connect("fired", _on_fired)

func _on_fired(bullet: Bullet) -> void:
	bullet.damage = round(bullet.damage * mult)
