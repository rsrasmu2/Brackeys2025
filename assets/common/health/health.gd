class_name Health
extends Node

signal health_changed(new_health: int)
signal died

@export var max_health: int = 100
@export var health: int:
	set(value):
		var new_health: int = clamp(value, 0, max_health)
		if health == new_health:
			return
		health = new_health
		emit_signal(health_changed.get_name(), health)
		if health == 0:
			emit_signal(died.get_name())

func _ready() -> void:
	health = max_health
