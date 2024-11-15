extends Node2D

func _on_timer_timeout():
	$AnimationPlayer.play("new_animation")
	Global.play_sound(Global.ThunderSFX)
	$Timer.wait_time = Global.pick_random([10, 15, 20, 6])
