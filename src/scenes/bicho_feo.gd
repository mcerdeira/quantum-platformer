extends AnimatedSprite2D
var started = false
var speed = 100
var try = 2

func _on_area_body_entered(body):
	if body and body.is_in_group("players"):
		started = false
		var options = {"pitch_scale": 0.7}
		Global.play_sound(Global.BichoFeoSFX, options)
		body.kill()
		$area.set_deferred("disabled", true)
		
func _physics_process(delta):
	if started:
		Global.shaker_obj.shake(2, 10)
		Global.shaker_obj.camera = $Camera2D
		speed += 10 * delta
		if speed > 250:
			speed = 250
		global_position.x += speed * delta
		Global.CHROM_FX.global_position.x += speed * delta
		
func slow_down():
	speed = 100

func _on_timer_timeout():
	started = true
	$explosions.start()

func _on_areagood_body_entered(body):
	if try > 0 and started and body and body.is_in_group("players"):
		try -= 1
		speed = 100
