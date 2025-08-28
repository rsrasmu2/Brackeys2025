extends AudioStreamPlayer

@export var player: Player

func _physics_process(delta: float) -> void:
	if player.is_on_floor() and $Timer.is_stopped() and player._target_velocity.length_squared() > 0.1:
		pitch_scale = randf_range(0.8, 1.2)
		play()
		$Timer.start()
		return

func _on_timer_timeout() -> void:
	if not player.is_on_floor() or player._target_velocity.length_squared() < 0.1:
		$Timer.stop()
		return
	pitch_scale = randf_range(0.7, 1.2)
	play()
