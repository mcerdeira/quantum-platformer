extends Node2D
@export var control : Control

func _ready():
	Global.boss_bar = self

func showme(name):
	$lbl_boss_name.text = name
	visible = true
	control.visible = true
	$"../perks1".visible = false
	$"../perks2".visible = false
	$"../perks3".visible = false
	$"../perks4".visible = false
	$"../perks5".visible = false
	$"../perks6".visible = false

func calc_life_bar(total, current):
	var scale_c = current / total
	$ProgressBarFillSpr0.scale.x = scale_c
