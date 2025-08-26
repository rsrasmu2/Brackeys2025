@tool
class_name HealthBar
extends Sprite3D

@export var health: Health
@export var size: Vector2:
	set(value):
		size = value
		$SubViewport.size = size

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	$SubViewport/ProgressBar.max_value = health.max_health
	$SubViewport/ProgressBar.value = health.health
	health.connect(health.health_changed.get_name(), _on_health_changed)

func _on_health_changed(new_value: int) -> void:
	$SubViewport/ProgressBar.value = new_value
