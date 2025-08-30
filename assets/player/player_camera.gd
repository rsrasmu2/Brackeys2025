extends Camera3D

@export var _sprint_fov: float = 82
@onready var _starting_fov: float = self.fov

func _on_dash_dash_started() -> void:
	var tween = create_tween()
	tween.tween_property(self, "fov", _sprint_fov, 0.1).set_ease(Tween.EASE_IN)

func _on_dash_dash_ended() -> void:
	var tween = create_tween()
	tween.tween_property(self, "fov", _starting_fov, 0.2).set_ease(Tween.EASE_OUT)
