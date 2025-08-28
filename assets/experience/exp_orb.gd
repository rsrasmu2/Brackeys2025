extends Area3D

var value: int

func init(starting_value: int) -> void:
	value = starting_value

func _on_body_entered(body: Node3D) -> void:
	body.get_node("Experience").experience += value
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()
