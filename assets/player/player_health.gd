extends ProgressBar

@export var health: Health


func _ready() -> void:
	max_value = health.max_health
	value = health.health

func _on_health_health_changed(new_health: int) -> void:
	value = new_health
