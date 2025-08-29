class_name Enemy
extends CharacterBody3D

signal state_changed(new_state: EnemyState)

@export var state_nodes: Dictionary[EnemyState, Node3D]
@export var knockback_node: Knockback
@export var material: StandardMaterial3D
@export var mesh: MeshInstance3D

@export var experience: int = 20

const GRAVITY: float = 9.8

var target_velocity: Vector3 = Vector3.ZERO
var knockback: Vector3 = Vector3.ZERO

var drop_exp: bool = true

var _target_states: Array = []

const EXP_SCENE := preload("res://assets/experience/exp_pickup.tscn")

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
	if mesh:
		mesh.mesh.surface_set_material(0, material)
	state_nodes[state].enter()

func _process(_delta: float) -> void:
	if len(_target_states) == 0:
		return
	

func _physics_process(delta: float) -> void:
	if not gravity_enabled:
		target_velocity.y = 0
	elif target_velocity.y < 0 and is_on_floor():
		target_velocity.y = 0
	else:
		target_velocity.y -= GRAVITY * delta
	
	velocity = target_velocity
	velocity.x = target_velocity.x
	velocity.z = target_velocity.z
	velocity += knockback
	
	move_and_slide()

func take_damage(amount: int, knockback_amount: Vector3, _source: Node) -> void: 
	$Health.health -= amount
	if knockback_node:
		knockback_node.add_knockback(knockback_amount)

func add_status_effect(effect: Node) -> void:
	$StatusEffects.add_child(effect)
	effect.apply(self)

func _on_health_died() -> void:
	if drop_exp:
		var orb := EXP_SCENE.instantiate()
		orb.init(experience)
		get_tree().root.add_child(orb)
		orb.global_transform = global_transform
	queue_free()
