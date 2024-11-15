extends AnimatedSprite2D
@export var master = false

func _on_frame_changed():
	if master: 
		if frame == 7:
			get_parent().thunder_sound()

func _on_animation_finished():
	$Timer.wait_time = 15
	$Timer.start()

func _on_timer_timeout():
	play("default")
