extends Node

const NAME: String = "Bullet Size"
const DESCRIPTION: String = "Increases the size of your bullets."

const BULLET_SIZE_EFFECT_SCENE := preload("res://assets/bullet/effects/bullet_size_effect.tscn")

func apply(player: Player) -> void:
	player.get_node("PlayerCamera/Gun").connect("fired", _on_fired)

func _on_fired(bullet: Bullet) -> void:
	bullet.add_effect(BULLET_SIZE_EFFECT_SCENE.instantiate())
