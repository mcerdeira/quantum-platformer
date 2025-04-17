extends AnimatableBody2D
var move = false
var up = false
var active = false
var watersplash = preload("res://scenes/Confeti.tscn")
var explodeloop = null

func _ready() -> void:
	visible = Global.BoatUnlocked
	active = Global.BoatUnlocked
	Global.BoatObj = self
	
func activate():
	Global.player_obj.locked_ctrls = true
	Global.shaker_obj.shake(10, 4.5)
	explodeloop = Global.play_sound(Global.ExplodeLoopSFX)
	visible = true
	$"../AnimationPlayer".play("new_animation")
	
func final_splash():
	active = true
	explodeloop.stop()
	Global.play_sound(Global.ExplosionsndSXF)
	splash()
	Global.player_obj.locked_ctrls = false
	
func splash():
	var count = randi_range(1, 2)
	for i in range(count):
		var sp = watersplash.instantiate()
		var aju = randi_range(0, 10) * Global.pick_random([1. -1])
		sp.global_position = Vector2(global_position.x + aju, global_position.y + 16)
		get_parent().add_child(sp)

func _physics_process(delta):
	if active:
		if move:
			position.x += 300 * delta 
		else:
			if up:
				position.y += 10 * delta
			else:	
				position.y -= 10 * delta
	
func _on_timer_timeout():
	move = !move

func _on_detector_body_entered(body):
	if body and body.is_in_group("players"):
		Global.player_obj.locked_ctrls = true
		$Timer.start()

func _on_timer_2_timeout():
	if !move:
		up = !up
