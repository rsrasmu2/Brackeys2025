class_name Experience
extends Node

@export var first_level_exp: int = 100
@export var level_up_mult: float = 1.2

@export var level_up_powerups: Array[PackedScene]

signal exp_changed(amount: int)
signal level_up(level: int)

var level: int = 1:
	set(value):
		if level != value:
			level = value
			$LevelUpAudio.play()
			emit_signal(level_up.get_name(), level)

var experience: int = 0:
	set(value):
		$"../ExpGainAudio".play_pitched()
		experience = value
		while experience >= next_level_exp:
			experience -= next_level_exp
			level += 1
			next_level_exp = round(next_level_exp * level_up_mult)
		emit_signal(exp_changed.get_name(), experience)

@onready var next_level_exp: int = self.first_level_exp
