extends CharacterBody2D
var count = 0
var is_active = true

func activate():
	$sprite.play()

func _on_sprite_animation_finished():
	if count < 5:
		is_active = false
		$sprite.speed_scale = 4
		$sprite.play()
	
	count += 1
	if count == 5:
		is_active = true
		$sprite.stop()
		$sprite.frame = 0
		count = 0
