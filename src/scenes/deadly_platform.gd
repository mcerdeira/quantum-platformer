extends StaticBody2D
var active = false
var exploded = false
var explosion_delay = 0

func _ready():
	if randi() % 5 != 0:
		queue_free()
		
func _physics_process(delta):
	if active and !exploded:
		$sprite.speed_scale += 1 * delta
		$Timer.wait_time -= 0.2 * delta
		if $sprite.speed_scale >= 3:
			exploded = true
			$Timer.stop()
			$sprite.stop()
			$sprite.animation = "exploded"
			explode()
	elif active and exploded:
		if explosion_delay > 0:
			explosion_delay -= 1 * delta
			if explosion_delay <= 0:
				$explosion.queue_free()
				$explosions.queue_free()
				$explosion_light.queue_free()
				$explosion_light2.queue_free()
				$explosion_light3.queue_free()
				$anim_explosion.queue_free()
				
		
func explode():
	Global.play_sound(Global.BombSFX, {}, global_position)
	$explosion/collider.set_deferred("disabled", false)
	explosion_delay = 1.2
	$explosion_light.enabled = true
	$explosion_light.enabled = true
	$explosion_light.enabled = true
	$anim_explosion.play("new_animation")
	$explosions.explode()
	

func _on_area_body_entered(body):
	if !active:
		if (body.is_in_group("enemies") or body.is_in_group("players") or body.is_in_group("interactuable")):
			active = true
			$Timer.start()
			$sprite.play()

func _on_visible_on_screen_enabler_2d_screen_entered():
	$VisibleOnScreenEnabler2D.queue_free()

func _on_timer_timeout():
	Global.play_sound(Global.BombTicSFX, {}, global_position) 
