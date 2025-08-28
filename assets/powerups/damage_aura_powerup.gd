extends Area3D

@export var damage: float = 20
@export var cooldown: float = 3

func _ready() -> void:
	$Timer.wait_time = cooldown

func _on_timer_timeout() -> void:
	for body in get_overlapping_bodies():
		if body.has_method("take_damage"):
			body.take_damage(damage, Vector3.ZERO, self)
