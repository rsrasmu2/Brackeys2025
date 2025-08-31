extends Area3D

@export var audio: AudioStreamPlayer
@export var damage: int = 15

var _player: Player
var _in_lava: bool = false

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		_player = body
		_in_lava = true
		if $Timer.is_stopped():
			audio.play()
			_player.take_damage(damage, Vector3.ZERO, self)
			$Timer.start()

func _on_body_exited(_body: Node3D) -> void:
	_in_lava = false

func _on_timer_timeout() -> void:
	if _in_lava:
		audio.play()
		_player.take_damage(damage, Vector3.ZERO, self)
		$Timer.start()
