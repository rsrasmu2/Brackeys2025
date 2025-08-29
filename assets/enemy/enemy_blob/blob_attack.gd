extends Area3D

@export var controller: Enemy
@export var target: EnemyTarget
@export var damage: int = 20
@export var knockback: float = 0.9
@export var animation_player: AnimationPlayer

var _dealt_damage: bool = false

func enter() -> void:
	_dealt_damage = false
	monitoring = false
	controller.look_at(target.target.global_position, Vector3.UP, true)
	animation_player.connect(animation_player.animation_finished.get_name(), _on_animation_finished)
	animation_player.play("attack")

func exit() -> void:
	animation_player.disconnect(animation_player.animation_finished.get_name(), _on_animation_finished)

func enable_hurtbox() -> void:
	monitoring = true
	await get_tree().physics_frame
	connect("body_entered", _on_area_3d_body_entered)
	var bodies: Array = get_overlapping_bodies()
	if len(bodies) > 0:
		for body: Node3D in bodies:
			if body.has_method("take_damage"):
				var displacement := (body.global_position - global_position)
				displacement.y = 0.5
				var direction := displacement.normalized()
				body.take_damage(damage, direction * knockback, controller)
				_dealt_damage = true

func disable_hurtbox() -> void:
	disconnect("body_entered", _on_area_3d_body_entered)
	monitoring = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if _dealt_damage:
		return
	if body.has_method("take_damage"):
		var direction := (body.global_position - global_position).normalized()
		body.take_damage(damage, direction * knockback, controller)
		_dealt_damage = true
		set_deferred("monitoring", false)
	

func _on_animation_finished(_animation_name: String) -> void:
	controller.state = Enemy.EnemyState.Idle
