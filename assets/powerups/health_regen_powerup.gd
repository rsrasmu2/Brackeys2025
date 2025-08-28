extends Node

@export var heal_amount: int = 10
@export var tick_rate: float = 2.0
var _health: Health

func _ready() -> void:
	$Timer.wait_time = tick_rate

func apply(player: Player) -> void:
	_health = player.get_node("Health")

func _on_timer_timeout() -> void:
	_health.health += heal_amount
