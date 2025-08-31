extends Node

const NAME: String = "Bullet Knockback"
const DESCRIPTION: String = "Adds a slight knockback to your bullets."

@export var amount: float = 2.5

func apply(player: Player) -> void:
	player.get_node("PlayerCamera/Gun").connect("fired", _on_fired)

func _on_fired(bullet: Bullet) -> void:
	bullet.knockback += amount
