extends Label

@export var gun: Gun

func _ready() -> void:
	_set_text()

func _on_gun_max_ammo_changed(_ammo: int) -> void:
	_set_text()

func _on_gun_current_ammo_changed(_current_ammo: int) -> void:
	_set_text()

func _set_text() -> void:
	text = str(gun.current_ammo) + " / " + str(gun.max_ammo)
