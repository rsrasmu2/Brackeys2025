class_name PitchRandomizer3D
extends AudioStreamPlayer3D

@export var min_pitch: float = 0.8
@export var max_pitch: float = 1.2

func play_pitched() -> void:
	pitch_scale = randf_range(min_pitch, max_pitch)
	play()
