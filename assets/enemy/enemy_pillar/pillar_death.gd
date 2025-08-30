extends Node3D

@export var controller: EnemyPillar
@export var health_bar: Node3D

func enter() -> void:
	$"../CollisionShape3D".disabled = true
	$"../GroundDetection".monitoring = false
	health_bar.change_visibility = false
	health_bar.visible = false
	$Timer.start()
	await $Timer.timeout
	var tween := create_tween()
	tween.tween_property(controller, "global_position", global_position - Vector3.UP * 10, 2.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await tween.finished
	controller.queue_free()
