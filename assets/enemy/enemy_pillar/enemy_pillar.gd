class_name EnemyPillar
extends AnimatableBody3D

signal state_changed(new_state: EnemyState)

@export var state_nodes: Dictionary[EnemyState, Node3D]
@export var experience: int = 50

var _target_states: Array = []
var drop_exp: bool = true

const EXP_SCENE := preload("res://assets/experience/exp_pickup.tscn")

enum EnemyState { Spawning, Idle, Following, Jumping, Attacking, Dying }
@onready var state: EnemyState = EnemyState.Spawning:
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

func spawn() -> void:
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
	if drop_exp:
		var orb := EXP_SCENE.instantiate()
		orb.init(experience)
		get_tree().root.add_child(orb)
		orb.global_position = global_position
	state = EnemyState.Dying
