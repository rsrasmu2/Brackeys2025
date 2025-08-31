class_name ExperienceGainAudio
extends AudioStreamPlayer

@export var experience: Experience

@export var min_pitch: float = 0.7
@export var max_pitch: float = 1.3

func play_pitched() -> void:
	pitch_scale = lerp(min_pitch, max_pitch, experience.experience / experience.next_level_exp)
	play()
