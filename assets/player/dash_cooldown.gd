extends ProgressBar

func _on_dash_cooldown_changed(cooldown: float) -> void:
	value = cooldown
