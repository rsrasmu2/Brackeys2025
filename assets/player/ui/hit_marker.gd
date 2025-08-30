extends Control

@export var _distance = 30
@export var _speed = 0.05
@export var _return_rate: float = 5

var _tween: Tween

func _process(delta: float) -> void:
	$Crosshair.position.x = lerp($Crosshair.position.x, -30.0, delta * _return_rate)
	$Crosshair2.position.y = lerp($Crosshair2.position.y, -30.0, delta * _return_rate)
	$Crosshair3.position.x = lerp($Crosshair3.position.x, 30.0, delta * _return_rate)
	$Crosshair4.position.y = lerp($Crosshair4.position.y, 30.0, delta * _return_rate)

func hit() -> void:
	visible = true
	$Timer.start()
	if _tween != null:
		_tween.kill()
	_tween = create_tween()
	_tween.set_parallel(true)
	_tween.tween_property($Crosshair, "position:x", $Crosshair.position.x + _distance, _speed)
	_tween.tween_property($Crosshair2, "position:y", $Crosshair2.position.y + _distance, _speed)
	_tween.tween_property($Crosshair3, "position:x", $Crosshair3.position.x - _distance, _speed)
	_tween.tween_property($Crosshair4, "position:y", $Crosshair4.position.y - _distance, _speed)

func _on_timer_timeout() -> void:
	visible = false
