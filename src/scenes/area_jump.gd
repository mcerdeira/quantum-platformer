extends Area2D
var particle = preload("res://scenes/particle_cloud.tscn")

func _physics_process(_delta):
	var overlapping_bodies = get_overlapping_bodies()
	for body in overlapping_bodies:
		if (body.is_in_group("enemies") or body.is_in_group("players") or body.is_in_group("interactuable")):
			if body.is_in_group("players") and body.is_on_stairs and body.grabbed:
				return
			Global.play_sound(Global.SpringSFX, {}, global_position)
			body.super_jump()
			if Global.TerminalNumber == Global.TerminalsEnum.TOMB:
				Global.emit($"../marker_cloud".global_position, 5)
				Global.emit($"../marker_cloud2".global_position, 5)
			else:
				Global.emit($"../marker_cloud".global_position, 5, particle)
				Global.emit($"../marker_cloud2".global_position, 5, particle)
			
			$"../AnimationPlayer2".play("new_animation")
