extends Area3D

@export var controller: EnemyPillar

func _physics_process(delta: float) -> void:
	if not monitoring:
		return
	if len(get_overlapping_bodies()) > 0:
		controller.global_position.y += 0.05
