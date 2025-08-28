extends Area3D

@export var text: String
@export var powerup: Resource

func _ready() -> void:
	$Label3D.text = text

func _on_body_entered(body: Node3D) -> void:
	if body.has_method("add_powerup"):
		body.add_powerup(powerup.instantiate())
		queue_free()
