class_name Bullet
extends Node3D

signal hit(body: Node3D)

var velocity: Vector3
var damage: int
var knockback: float

func _physics_process(delta: float) -> void:
	position += velocity * delta

func init(starting_velocity: Vector3, starting_damage: int, starting_knockback: float) -> void:
	velocity = starting_velocity
	damage = starting_damage
	knockback = starting_knockback

func add_effect(effect: Node) -> void:
	$Effects.add_child(effect)
	effect.apply(self)

func _on_area_3d_body_entered(body: Node3D) -> void:
	emit_signal(hit.get_name(), body)
	if body.has_method("take_damage"):
		body.take_damage(damage, basis.z * knockback, self)
	queue_free()

func _on_despawn_timer_timeout() -> void:
	queue_free()
