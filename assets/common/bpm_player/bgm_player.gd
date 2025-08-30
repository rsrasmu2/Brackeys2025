class_name BgmPlayer
extends Node

@export var autoplay: bool = true

@export var volume_db: float = -20
@export var fade_in_time: float = 2.0
@export var fade_out_time: float = 8.0

@export var beginning: AudioStream
@export var base_loop: AudioStream
@export var intensity_1_loop: AudioStream
@export var intensity_2_loop: AudioStream

const MUTE_VOLUME: float = -80

var tween: Tween

func _ready() -> void:
	if not autoplay:
		return
	
	$Beginning.stream = beginning
	$Beginning.volume_db = volume_db
	
	$BaseLoop.stream = base_loop
	$BaseLoop.volume_db = volume_db
	
	$Level1.stream = intensity_1_loop
	$Level1.volume_db = MUTE_VOLUME
	
	$Level2.stream = intensity_2_loop
	$Level2.volume_db = MUTE_VOLUME
	
	if $Beginning.stream != null:
		$Beginning.play()
		await $Beginning.finished
	
	$BaseLoop.play()
	$Level1.play()
	$Level2.play()

func set_intensity(level: int) -> void:
	if tween != null:
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	match level:
		0:
			tween.tween_property($Level1, "volume_db", MUTE_VOLUME, fade_out_time)
			tween.tween_property($Level2, "volume_db", MUTE_VOLUME, fade_out_time)
		1:
			tween.tween_property($Level1, "volume_db", volume_db, fade_in_time)
			tween.tween_property($Level2, "volume_db", MUTE_VOLUME, fade_out_time)
		2:
			tween.tween_property($Level1, "volume_db", volume_db, fade_in_time)
			tween.tween_property($Level2, "volume_db", volume_db, fade_in_time)

func fade_bgm() -> void:
	if tween != null:
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($BaseLoop, "volume_db", MUTE_VOLUME, fade_out_time * 2.0)
	tween.tween_property($Level1, "volume_db", MUTE_VOLUME, fade_out_time * 2.0)
	tween.tween_property($Level2, "volume_db", MUTE_VOLUME, fade_out_time * 2.0)
