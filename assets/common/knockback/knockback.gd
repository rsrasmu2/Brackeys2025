class_name Knockback
extends Node

@export var body: CharacterBody3D
@export var falloff: float = 5

var direction: Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	if direction.length_squared() == 0:
		body.knockback = Vector3.ZERO
		return
	if direction.length_squared() < 0.05:
		direction = Vector3.ZERO
		body.knockback = Vector3.ZERO
		return
	body.knockback = direction
	direction.y = 0
	var weight: float = min(delta * falloff, 1)
	direction = lerp(direction, Vector3.ZERO, weight)

func add_knockback(amount: Vector3) -> void:
	if amount.length_squared() < direction.length_squared() * 2.0:
		return
	direction += amount
