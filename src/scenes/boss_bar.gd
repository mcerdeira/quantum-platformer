extends Node2D
@export var control : Control

func _ready():
	Global.boss_bar = self
	
func showme():
	visible = true
	control.visible = true

func calc_life_bar(total, current):
	$ProgressBarFillSpr0.scale.x = current / total
