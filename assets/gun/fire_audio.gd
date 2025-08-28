extends AudioStreamPlayer


func _on_gun_fired(_bullet: Bullet) -> void:
	pitch_scale = randf_range(1.0, 1.3)
	play()
