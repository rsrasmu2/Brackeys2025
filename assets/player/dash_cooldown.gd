extends ProgressBar

func _on_dash_cooldown_changed(cooldown: float) -> void:
	value = cooldown
	if value == 1:
		self_modulate = Color(0.9, 1.0, 1.0)
	else:
		self_modulate = Color(0.7, 0.9, 1.0)
