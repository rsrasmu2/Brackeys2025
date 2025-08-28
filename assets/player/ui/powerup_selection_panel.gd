extends Panel

@export var player: Player

func _ready() -> void:
	for element in %PowerupElements.get_children():
		element.connect("powerup_selected", _on_powerup_selected.bind(element))
	visible = false

func show_powerups(powerups: Array[PackedScene]) -> void:
	for i: int in range(%PowerupElements.get_child_count()):
		%PowerupElements.get_child(i).set_powerup(powerups[i])
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_powerup_selected(powerup: Node, element: Node) -> void:
	print("Selected")
	player.add_powerup(powerup)
	for e: PowerupUiElement in %PowerupElements.get_children():
		if e != element:
			e.clear()
	visible = false
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
