class_name Health
extends Node

signal health_changed(new_health: int)
signal max_health_changed(new_max_health: int)
signal died

var invulnerable: bool = false

@export var max_health: int = 100:
	set(value):
		if max_health == value:
			return
		max_health = value
		emit_signal(max_health_changed.get_name(), max_health)
		if health > max_health:
			health = max_health
	
var health: int:
	set(value):
		if invulnerable:
			return
		var new_health: int = clamp(value, 0, max_health)
		if health == new_health:
			return
		health = new_health
		emit_signal(health_changed.get_name(), health)
		if health == 0:
			emit_signal(died.get_name())

@export var regen: float = 2

func _ready() -> void:
	health = max_health

func _on_timer_timeout() -> void:
	health = round(health + regen)
