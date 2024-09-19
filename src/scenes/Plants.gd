extends Area2D
@export var fixed = false

func _on_body_entered(body):
	if body and (body.is_in_group("players") or body.is_in_group("enemies")):
		$AnimationPlayer.play("new_animation")
		$Timer.start() 
		Global.play_sound(Global.pick_random([Global.PlantSFX, Global.Plant2SFX]))

func _ready():
	if !fixed:
		scale = Global.pick_random([Vector2(1, 1), Vector2(2, 2), Vector2(3, 3)])

func _on_timer_timeout():
	$AnimationPlayer.stop()
