extends Node3D

@export var controller: Player

func _ready() -> void:
	for child in get_children():
		if child.has_method("apply"):
			child.apply(controller)
