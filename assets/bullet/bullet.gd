class_name Bullet
extends Node3D

var velocity: Vector3

func _physics_process(delta: float) -> void:
	position += velocity * delta

func init(starting_velocity: Vector3) -> void:
	velocity = starting_velocity

func _on_area_3d_body_entered(_body: Node3D) -> void:
	queue_free()

func _on_area_3d_area_entered(_area: Area3D) -> void:
	queue_free()

func _on_despawn_timer_timeout() -> void:
	queue_free()
