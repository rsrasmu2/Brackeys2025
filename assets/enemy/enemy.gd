class_name Enemy
extends CharacterBody3D

func take_damage(amount: int) -> void:
	$Health.health -= amount

func _on_health_died() -> void:
	queue_free()
