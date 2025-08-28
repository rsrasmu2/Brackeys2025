extends Node

const NAME: String = "Burning"
const DESCRIPTION: String = "Your bullets burn enemies on impact, dealing damage over times."

const BURN_EFFECT_SCENE := preload("res://assets/bullet/effects/burn_effect.tscn")

func apply(player: Player) -> void:
	player.get_node("PlayerCamera/Gun").connect("fired", _on_fired)

func _on_fired(bullet: Bullet) -> void:
	bullet.add_effect(BURN_EFFECT_SCENE.instantiate())
