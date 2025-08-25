class_name HealthBar
extends Sprite3D

@export var health: Health

func _ready() -> void:
	$SubViewport/ProgressBar.max_value = health.max_health
	$SubViewport/ProgressBar.value = health.health
	health.connect(health.health_changed.get_name(), _on_health_changed)

func _on_health_changed(new_value: int) -> void:
	$SubViewport/ProgressBar.value = new_value
