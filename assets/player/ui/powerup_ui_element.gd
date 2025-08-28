class_name PowerupUiElement
extends Panel

signal powerup_selected(powerup: Node)

var _powerup: Node

func set_powerup(powerup: PackedScene) -> void:
	_powerup = powerup.instantiate()
	$MarginContainer/VBoxContainer/PowerupName.text = _powerup.NAME
	$MarginContainer/VBoxContainer/PowerupDescription.text = _powerup.DESCRIPTION

func _on_button_pressed() -> void:
	emit_signal(powerup_selected.get_name(), _powerup)

func clear() -> void:
	_powerup.queue_free()
