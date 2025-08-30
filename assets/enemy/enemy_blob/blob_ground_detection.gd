extends Node

@export var controller: Enemy

signal left_ground
signal landed

var _grounded: bool = true

func _physics_process(_delta: float) -> void:
	if not _grounded and controller.is_on_floor():
		_grounded = true
		emit_signal(landed.get_name())
	elif _grounded and not controller.is_on_floor():
		_grounded = false
		emit_signal(left_ground.get_name())
