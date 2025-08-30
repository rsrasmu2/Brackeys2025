extends Control

@export var _speed: float = 0.05
@export var _distance: float = 20
@export var _return_rate: float = 5

var _tween: Tween

func _process(delta: float) -> void:
	$Crosshair.position.x = lerp($Crosshair.position.x, -36.0, delta * _return_rate)
	$Crosshair2.position.y = lerp($Crosshair2.position.y, -36.0, delta * _return_rate)
	$Crosshair3.position.x = lerp($Crosshair3.position.x, 36.0, delta * _return_rate)
	$Crosshair4.position.y = lerp($Crosshair4.position.y, 36.0, delta * _return_rate)

func fire(_bullet: Bullet) -> void:
	if _tween != null:
		_tween.kill()
	_tween = create_tween()
	_tween.set_parallel(true)
	_tween.tween_property($Crosshair, "position:x", $Crosshair.position.x + _distance, _speed)
	_tween.tween_property($Crosshair2, "position:y", $Crosshair2.position.y + _distance, _speed)
	_tween.tween_property($Crosshair3, "position:x", $Crosshair3.position.x - _distance, _speed)
	_tween.tween_property($Crosshair4, "position:y", $Crosshair4.position.y - _distance, _speed)
