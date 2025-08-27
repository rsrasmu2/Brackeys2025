extends Area3D

@export var controller: Enemy

func _physics_process(delta: float) -> void:
	if len(get_overlapping_bodies()) > 0:
		controller.global_position.y += 0.05
