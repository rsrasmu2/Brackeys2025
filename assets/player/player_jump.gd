class_name PlayerJump
extends Node

@export var player: Player
@export var jump_velocity: float = 5.5

var extra_jumps: int = 0
@onready var _remaining_extra_jumps: int = self.extra_jumps

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		try_jump()

func _physics_process(delta: float) -> void:
	if player.is_on_floor():
		_remaining_extra_jumps = extra_jumps

func try_jump() -> void:
	if player.is_on_floor():
		player.velocity.y = jump_velocity
	elif _remaining_extra_jumps > 0:
		_remaining_extra_jumps -= 1
		player.velocity.y = jump_velocity
