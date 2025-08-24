class_name PlayerMovement
extends Node

@export var target: Player 

func _process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	direction = direction.rotated(-target.rotation.y)
	target.set_horizontal_velocity(direction)
