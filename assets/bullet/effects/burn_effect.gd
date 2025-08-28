extends Node

const BURN_STATUS_SCENE := preload("res://assets/common/status_effects/burn_status.tscn")

func apply(bullet: Bullet) -> void:
	bullet.connect("hit", _on_hit)

func _on_hit(body: Node3D) -> void:
	if body.has_method("add_status_effect"):
		body.add_status_effect(BURN_STATUS_SCENE.instantiate())
