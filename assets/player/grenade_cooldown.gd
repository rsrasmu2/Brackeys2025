extends ProgressBar

@export var player_grenade_timer: Timer

func _ready() -> void:
	max_value = player_grenade_timer.wait_time

func _process(_delta: float) -> void:
	value = max_value - player_grenade_timer.time_left
