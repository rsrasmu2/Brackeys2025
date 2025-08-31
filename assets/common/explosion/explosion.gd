extends Node3D

var streaks_min := 0.29
var streaks_max := 0.29
var clouds_min := 0.49
var clouds_max := 0.51
var flare_min := 1.0
var flare_max := 1.0

func _ready() -> void:
	await $AnimationPlayer.animation_finished
	queue_free()

func init(effect_scale: float) -> void:
	$VFX_Explosion_Streaks.process_material.scale_min = streaks_min * effect_scale
	$VFX_Explosion_Streaks.process_material.scale_max = streaks_max * effect_scale
	$VFX_Explosion_Clouds.process_material.scale_min = clouds_min * effect_scale
	$VFX_Explosion_Clouds.process_material.scale_max = clouds_max * effect_scale
	$Flare.process_material.scale_min = flare_min * effect_scale
	$Flare.process_material.scale_max = flare_max * effect_scale
