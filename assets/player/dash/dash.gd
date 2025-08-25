extends Node

@export var dasher: Player

@export var dash_speed: float = 20
@export var dash_duration: float = 0.1:
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

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dash") and $Cooldown.is_stopped() and remaining_charges > 0:
		dash()

func dash() -> void:
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
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(dasher, "current_dash_speed", 0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
