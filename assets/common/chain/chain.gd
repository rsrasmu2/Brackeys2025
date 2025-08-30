extends Node3D

@export var x_speed = 1
@export var y_speed = 5

func _process(delta: float) -> void:
	$MeshInstance3D.get_active_material(0).uv1_offset.x += x_speed * delta
	$MeshInstance3D.get_active_material(0).uv1_offset.y += y_speed * delta

func init(from: Vector3, to: Vector3) -> void:
	global_position = from
	scale.z = from.distance_to(to)
	look_at(to)
	global_position.y += 0.5


func _on_timer_timeout() -> void:
	queue_free()
