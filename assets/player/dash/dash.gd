class_name Dash
extends Node

signal dash_started
signal dash_ended
signal cooldown_changed(cooldown: float)

@export var dasher: Player

@export var dash_speed: float = 20
@export var dash_duration: float = 0.15:
	set(value):
		dash_duration = value
		$DashTimer.wait_time = dash_duration

@export var max_charges: int = 1
@export var cooldown: float = 1.8:
	set(value):
		cooldown = value
		$Cooldown.wait_time = cooldown

@onready var remaining_charges: int = self.max_charges:
	set(value):
		var new_charges: int = clamp(value, 0, max_charges)
		remaining_charges = new_charges

func _ready() -> void:
	$DashTimer.wait_time = dash_duration
	$Cooldown.wait_time = cooldown

func _process(_delta: float) -> void:
	if not $Cooldown.is_stopped():
		var percent: float = 1.0 - ($Cooldown.time_left / $Cooldown.wait_time)
		emit_signal(cooldown_changed.get_name(), percent)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dash") and $DashTimer.is_stopped() and remaining_charges > 0:
		dash()

func dash() -> void:
	emit_signal(dash_started.get_name())
	$AudioStreamPlayer.play()
	remaining_charges -= 1
	dasher.current_dash_speed = dash_speed
	$DashTimer.start()
	if $Cooldown.is_stopped():
		$Cooldown.start()


func _on_cooldown_timeout() -> void:
	remaining_charges += 1
	if remaining_charges != max_charges:
		$Cooldown.start()


func _on_dash_timer_timeout() -> void:
	dasher.current_dash_speed = 0
	emit_signal(dash_ended.get_name())
