extends Node

const NAME: String = "Arcing"
const DESCRIPTION: String = "Shooting an enemy causes lightning to chain across up to three nearby enemies."

const ARCING_EFFECT_SCENE := preload("res://assets/bullet/effects/arcing_effect.tscn")

func apply(player: Player) -> void:
	player.get_node("PlayerCamera/Gun").connect("fired", _on_fired)

func _on_fired(bullet: Bullet) -> void:
	bullet.add_effect(ARCING_EFFECT_SCENE.instantiate())
