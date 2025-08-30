extends Node3D

const GRENADE_SCENE := preload("res://assets/player/grenade.tscn")

@export var controller: Player

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("grenade"):
		if $Cooldown.is_stopped():
			$Cooldown.start()
			var grenade := GRENADE_SCENE.instantiate()
			get_tree().root.add_child(grenade)
			grenade.global_transform = global_transform
			grenade.initial_velocity = controller.velocity
