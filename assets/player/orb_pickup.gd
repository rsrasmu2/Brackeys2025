class_name OrbPickup
extends Area3D

@export var player: Player

@export var experience: Experience
@export var pickup_range: float = 4:
	set(value):
		pickup_range = value
		$CollisionShape3D.shape.radius = range

func _on_area_entered(area: Area3D) -> void:
	area.pickup(player)
