class_name PlayerMovement
extends Node

@export var target: Player 

func _process(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	direction = direction.rotated(-target.rotation.y)
	target.set_horizontal_velocity(direction)
	
	if Input.is_action_just_pressed("jump"):
		target.try_jump()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("sprint"):
		target.is_sprinting = !target.is_sprinting
