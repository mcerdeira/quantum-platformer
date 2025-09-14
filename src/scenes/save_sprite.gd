extends Node2D

func _ready() -> void:
	visible = false
	Global.save_icon = self
	show_me()

func show_me():
	visible = true
	$anim.play("new_animation")

func hide_me():
	visible = false
	Global.save_icon = null
