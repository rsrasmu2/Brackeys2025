class_name OrbPickup
extends Area3D

@export var experience: Experience
@export var range: float = 4:
	set(value):
		range = value
		$CollisionShape3D.shape.radius = range

func _on_area_entered(area: Area3D) -> void:
	experience.experience += area.value
	area.queue_free()
