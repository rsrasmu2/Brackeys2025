extends ProgressBar


func _on_dash_cooldown_changed(cooldown: float) -> void:
	value = cooldown
	if cooldown >= 0.99:
		self_modulate = Color(0.9, 1, 1, 1)
	else:
		self_modulate = Color(0.0, 1, 1, 1)
