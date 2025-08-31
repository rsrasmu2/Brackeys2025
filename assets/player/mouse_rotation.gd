class_name MouseRotation
extends Node

@export var mouse_sensitivity: float = 0.003
var adjusted_sensitivity: float

@export var min_x_rotation: float = -60
@export var max_x_rotation: float = 60

@export var horizontal_rotator: Node3D
@export var vertical_rotator: Node3D

@onready var _min_x_rad: float = deg_to_rad(min_x_rotation)
@onready var _max_x_rad: float = deg_to_rad(max_x_rotation)

var _delta: float

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if OS.has_feature("web"):
		var pixel_ratio: float = JavaScriptBridge.eval("window.devicePixelRatio")
		adjusted_sensitivity = mouse_sensitivity / pixel_ratio
	else:
		adjusted_sensitivity = mouse_sensitivity

func _process(delta: float) -> void:
	_delta = delta

func _input(event: InputEvent) -> void:
	# Handle mouse capture/uncapture
	if event.is_action_pressed("free_mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event.is_action_pressed("refocus_game") and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	# Handle mouse movement
	if event is not InputEventMouseMotion:
		return
		
	horizontal_rotator.rotate_y(-event.relative.x * adjusted_sensitivity)
	var target_vertical_rotation: float = clamp(vertical_rotator.rotation.x - event.relative.y * adjusted_sensitivity, _min_x_rad, _max_x_rad)
	vertical_rotator.rotation.x = target_vertical_rotation

func _on_death() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	set_process_input(false)
