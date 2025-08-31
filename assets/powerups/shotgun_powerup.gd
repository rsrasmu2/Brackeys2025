extends Node

@export var shots_cooldown: int = 4
@export var extra_bullets: int = 4
@export var max_spread_degrees: float = 15
@export var extra_bullet_damage: int = 30
@export var extra_bullet_knockback: float = 0

var shots_until: int = 0

const NAME: String = "Shotgun"
const DESCRIPTION: String = "Every 4 shots, shoot 4 additional bullets."

const BULLET_SCENE := preload("res://assets/bullet/bullet.tscn")

@onready var _max_spread: float = deg_to_rad(max_spread_degrees)

func apply(player: Player) -> void:
	player.get_node("PlayerCamera/Gun").connect("fired", _on_fired)

func _on_fired(bullet: Bullet) -> void:
	if shots_until > 0:
		shots_until -= 1
		return
	for _i: int in range(extra_bullets):
		var extra_bullet: Bullet = BULLET_SCENE.instantiate()
		get_tree().root.add_child(extra_bullet)
		extra_bullet.global_position = bullet.global_position
		var velocity := bullet.velocity
		velocity = velocity.rotated(bullet.basis.x, randf_range(-_max_spread, _max_spread))
		velocity = velocity.rotated(bullet.basis.y, randf_range(-_max_spread, _max_spread))
		
		extra_bullet.init(velocity, extra_bullet_damage, extra_bullet_knockback)
		shots_until = shots_cooldown
