extends Node

@export var mouse_sensitivity: float = 0.005

@export var min_x_rotation: float = -60
@export var max_x_rotation: float = 60

@export var horizontal_rotator: Node3D
@export var vertical_rotator: Node3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func _input(event: InputEvent) -> void:
	# Handle mouse capture/uncapture
	if event.is_action_pressed("free_mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("refocus_game") and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	if event is not InputEventMouseMotion:
		return
		
	horizontal_rotator.rotate_y(-event.relative.x * mouse_sensitivity)
	var target_vertical_rotation: float = clamp(vertical_rotator.rotation.x - event.relative.y * mouse_sensitivity, min_x_rotation, max_x_rotation)
	vertical_rotator.rotate_x(target_vertical_rotation - vertical_rotator.rotation.x)
