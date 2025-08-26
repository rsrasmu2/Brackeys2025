class_name Enemy
extends CharacterBody3D

signal state_changed(new_state: EnemyState)

@export var state_nodes: Dictionary[EnemyState, Node3D]

const GRAVITY: float = 9.8

var _target_states: Array = []

enum EnemyState { Idle, Following, Jumping, Attacking }
@onready var state: EnemyState = EnemyState.Idle:
	set(value):
		if state == value:
			return
		var state_node: Node3D = state_nodes[state]
		if state_node and state_node.has_method("exit"):
			state_node.exit()
		state = value
		state_node = state_nodes[state]
		if state_node and state_node.has_method("enter"):
			state_node.enter()
		emit_signal(state_changed.get_name(), state)

var gravity_enabled: bool = true

func _ready() -> void:
	state_nodes[state].enter()

func _process(_delta: float) -> void:
	if len(_target_states) == 0:
		return
	

func _physics_process(delta: float) -> void:
	if not gravity_enabled:
		velocity.y = 0
	elif velocity.y < 0 and is_on_floor():
		velocity.y = 0
	else:
		velocity.y -= GRAVITY * delta
		
	move_and_slide()

func take_damage(amount: int) -> void: 
	$Health.health -= amount

func _on_health_died() -> void:
	queue_free()
