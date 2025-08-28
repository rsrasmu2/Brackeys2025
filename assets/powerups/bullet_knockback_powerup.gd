extends Node

@export var amount: float = 2

func apply(player: Player) -> void:
	player.get_node("PlayerCamera/Gun").connect("fired", _on_fired)

func _on_fired(bullet: Bullet) -> void:
	bullet.knockback += amount
