extends AudioStreamPlayer


func _on_gun_fired(_bullet: Bullet) -> void:
	pitch_scale = randf_range(0.8, 1.2)
	play()
