extends Node

const EXPLOSION_EFFECT_SCENE := preload("res://assets/bullet/effects/bullet_explosion_effect.tscn")

func apply(player: Player) -> void:
	player.get_node("PlayerCamera/Gun").connect("fired", _on_fired)

func _on_fired(bullet: Bullet) -> void:
	bullet.add_effect(EXPLOSION_EFFECT_SCENE.instantiate())
