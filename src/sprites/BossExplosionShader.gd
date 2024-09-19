extends Node2D

func start():
	visible = true
	$AnimationPlayer.play("new_animation")	
	Global.play_sound(Global.BOSS1RoarSFX)
