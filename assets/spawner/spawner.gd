extends StaticBody3D

@export var spawn_distance: float = 4.0

const ENEMY_SCENES: Dictionary = {
	0: preload("res://assets/enemy/enemy_blob/enemy_blob.tscn")
}

func _ready() -> void:
	await get_tree().root.ready
	spawn()

func take_damage(amount: int) -> void:
	$Health.health -= amount
	
func spawn() -> void:
	var enemy: Enemy = ENEMY_SCENES[0].instantiate()
	get_tree().root.add_child(enemy)
	var facing: Vector3 = Vector3.FORWARD.rotated(Vector3.UP, randf_range(-PI, PI))
	enemy.global_position = global_position + facing * spawn_distance
	enemy.look_at(enemy.global_position + facing)

func _on_timer_timeout() -> void:
	spawn()

func _on_health_died() -> void:
	queue_free()
