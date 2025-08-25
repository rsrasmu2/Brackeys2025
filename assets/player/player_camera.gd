extends Camera3D

@export var _sprint_fov: float = 80
@onready var _starting_fov: float = self.fov

func _on_player_is_sprinting_changed(is_sprinting: bool) -> void:
	var tween: Tween = get_tree().create_tween()
	if is_sprinting:
		tween.tween_property(self, "fov", _sprint_fov, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	else:
		tween.tween_property(self, "fov", _starting_fov, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
