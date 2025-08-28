class_name EnemyPillar
extends AnimatableBody3D

signal state_changed(new_state: EnemyState)

@export var state_nodes: Dictionary[EnemyState, Node3D]

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

func _ready() -> void:
	state_nodes[state].enter()

func _process(_delta: float) -> void:
	if len(_target_states) == 0:
		return

func take_damage(amount: int, _knockback_amount: Vector3, _source: Node) -> void: 
	$Health.health -= amount

func add_status_effect(effect: Node) -> void:
	$StatusEffects.add_child(effect)
	effect.apply(self)

func _on_health_died() -> void:
	queue_free()
