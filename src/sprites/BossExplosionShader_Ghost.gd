extends Node2D
var ttl = 1.3

func _physics_process(delta):
	if ttl > 0:
		ttl -= 1 * delta
		if ttl <= 0:
			start()

func start():
	$AnimationPlayer.play("new_animation")	
	Global.play_sound(Global.BOSS1RoarSFX)
	Ambience.play(Global.CaveAmbienceSFX)
