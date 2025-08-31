extends Area3D

const GRAVITY: float = 9.8
var _gravity: float = 0

@export var THROW_SPEED: float = 10

@export var damage: int = 60
@export var radius: float = 8

var initial_velocity: Vector3 = Vector3.ZERO

func explode() -> void:
	var space := get_world_3d().direct_space_state
	var shape := SphereShape3D.new()
	shape.radius = radius
	var params := PhysicsShapeQueryParameters3D.new()
	params.shape = shape
	params.transform = transform
	params.collision_mask = 4
	var collisions := space.intersect_shape(params)
	for collision: Dictionary in collisions:
		var other: Node3D = collision["collider"]
		if other.has_method("take_damage"):
			other.take_damage(damage, Vector3.ZERO, self)
	queue_free()

func _on_body_entered(_body: Node3D) -> void:
	explode()

func _physics_process(delta: float) -> void:
	global_position += (initial_velocity * delta) + -global_basis.z * (THROW_SPEED * delta)
	_gravity += GRAVITY * delta
	global_position.y -= _gravity * delta
