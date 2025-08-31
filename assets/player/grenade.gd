extends Area3D

const GRAVITY: float = 9.8
var _gravity: float = 0

@export var THROW_SPEED: float = 10

@export var damage: int = 60
@export var radius: float = 12

@export var knockback: float = 4.0

var initial_velocity: Vector3 = Vector3.ZERO

const explosion := preload("res://assets/common/explosion/explosion.tscn")

func explode() -> void:
	var exp_node := explosion.instantiate()
	get_tree().root.add_child(exp_node)
	exp_node.global_position = global_position
	exp_node.init(radius)
	var space := get_world_3d().direct_space_state
	var shape := SphereShape3D.new()
	shape.radius = radius
	var params := PhysicsShapeQueryParameters3D.new()
	params.shape = shape
	params.transform = transform
	params.collision_mask = 4
	var collisions := space.intersect_shape(params)
	var rids: Array = []
	for collision: Dictionary in collisions:
		if rids.has(collision["rid"]):
			continue
		rids.push_back(collision["rid"])
		var other: Node3D = collision["collider"]
		if other.has_method("take_damage"):
			var direction := global_position.direction_to(other.global_position)
			other.take_damage(damage, direction * knockback, self)
	queue_free()

func _on_body_entered(_body: Node3D) -> void:
	explode()

func _physics_process(delta: float) -> void:
	global_position += (initial_velocity * delta) + -global_basis.z * (THROW_SPEED * delta)
	_gravity += GRAVITY * delta
	global_position.y -= _gravity * delta
