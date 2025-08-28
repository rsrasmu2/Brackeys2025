extends Node

@export var damage: int = 2
@export var ticks: int = 20

var _target: Node

func apply(target: Node) -> void:
	if !target.has_method("take_damage"):
		queue_free()
		return
	
	_target = target

func _on_timer_timeout() -> void:
	_target.take_damage(damage, Vector3.ZERO, self)
	ticks -= 1
	if ticks == 0:
		queue_free()
