class_name Enemy
extends CharacterBody3D

@export var animation_player: AnimationPlayer

enum EnemyState { Idle, Following, Jumping, Attacking }
@onready var state: EnemyState = EnemyState.Idle:
	set(value):
		if state == value:
			return
		state = value
		match state:
			EnemyState.Idle:
				animation_player.play("idle")
			EnemyState.Following:
				animation_player.play("walk")
				

func _ready() -> void:
	state = EnemyState.Following

func _physics_process(_delta: float) -> void:
	move_and_slide()

func take_damage(amount: int) -> void: 
	$Health.health -= amount

func _on_health_died() -> void:
	queue_free()
