extends AnimatableBody3D

@export var controller: Enemy

func take_damage(amount: int, knockback_amount: Vector3, source: Node) -> void:
	print("Taking damage???")
	controller.take_damage(amount, knockback_amount, source)

func add_status_effect(effect: Node) -> void:
	controller.add_status_effect(effect)
