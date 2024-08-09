extends StaticBody2D
var active = false
var exploded = false
var explosion_delay = 0

func _ready():
	if randi() % 5 != 0:
		queue_free()
		
func _physics_process(delta):
	if active and !exploded:
		$sprite.speed_scale += (1 * Global.time_speed) * delta
		if $sprite.speed_scale >= 3:
			exploded = true
			$sprite.stop()
			$sprite.animation = "exploded"
			explode()
	elif active and exploded:
		if explosion_delay > 0:
			explosion_delay -= (1 * Global.time_speed) * delta
			if explosion_delay <= 0:
				$explosion.queue_free()
				$explosions.queue_free()
		
func explode():
	$explosion/collider.set_deferred("disabled", false)
	explosion_delay = 1.2
	$explosions.explode()

func _on_area_body_entered(body):
	if !active:
		if (body.is_in_group("enemies") or body.is_in_group("players") or body.is_in_group("interactuable")):
			active = true
			$sprite.play()

func _on_visible_on_screen_enabler_2d_screen_entered():
	$VisibleOnScreenEnabler2D.queue_free()
