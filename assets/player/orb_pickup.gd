class_name OrbPickup
extends Area3D

@export var player: Player
@export var experience: Experience

@export var pickup_range: float = 6:
	set(value):
		pickup_range = value
		var shape := SphereShape3D.new()
		shape.radius = value
		$CollisionShape3D.shape = shape

func _on_area_entered(area: Area3D) -> void:
	area.pickup(player)
