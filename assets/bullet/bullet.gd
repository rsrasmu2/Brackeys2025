class_name Bullet
extends Node3D

var velocity: Vector3
var damage: int
var knockback: float

func _physics_process(delta: float) -> void:
	position += velocity * delta

func init(starting_velocity: Vector3, starting_damage: int, starting_knockback: float) -> void:
	velocity = starting_velocity
	damage = starting_damage
	knockback = starting_knockback

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage, basis.z * knockback)
	queue_free()

func _on_despawn_timer_timeout() -> void:
	queue_free()
