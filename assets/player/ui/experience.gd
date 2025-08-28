extends ProgressBar

@export var experience: Experience

func _on_experience_exp_changed(amount: int) -> void:
	max_value = experience.next_level_exp
	value = amount
