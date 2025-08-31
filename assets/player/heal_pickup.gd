extends Area3D

@export var heal_amount: int = 10
@export var rotate_rate: float = 60

func _process(delta: float) -> void:
	rotate_y(deg_to_rad(rotate_rate) * delta)

func pickup(player: Player) -> void:
	player.get_node("Health").health += heal_amount
	queue_free()
