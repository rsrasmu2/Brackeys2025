class_name ShieldPowerup
extends AnimatableBody3D

const NAME: String = "Shield"
const DESCRIPTION: String = "You gain a shield that rotates around you, preventing damage and knocking back enemies that hit it."

@export var speed_degrees: float = 3
@export var retaliatory_knockback: float = 8

func apply(player: Player) -> void:
	player.shields.push_back(self)
	var rads: float = TAU / player.shields.size()
	for i in range(player.shields.size()):
		player.shields[i].rotation.y = rads * i

func _physics_process(delta: float) -> void:
	rotate_y(speed_degrees * delta)

func take_damage(_damage: int, _knockback: Vector3, source: Node) -> void:
	if source.has_method("take_damage"):
		var displacement: Vector3 = global_position - source.global_position
		displacement.y = 0
		var direction := displacement.normalized()
		source.take_damage(20, direction * retaliatory_knockback, self)
