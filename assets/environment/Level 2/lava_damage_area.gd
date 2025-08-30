extends Area3D

var player: Player

func _on_body_entered(body: Node3D) -> void:
	player = body
	$Timer.start()

func _on_body_exited(body: Node3D) -> void:
	player = body
	$Timer.stop()

func _on_timer_timeout() -> void:
	if player.has_method("take_damage"):
		player.take_damage(15, Vector3.UP * 18, self)
