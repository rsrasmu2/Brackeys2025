class_name EnemyTarget
extends Node

var target: Player:
	get():
		if target == null:
			target = get_tree().get_first_node_in_group("Player")
		return target
