extends Area3D


@export var experience: Experience

func _on_area_entered(area: Area3D) -> void:
	experience.experience += area.value
	area.queue_free()
