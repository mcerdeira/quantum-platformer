extends Area2D
var active = false
var opened = false
var player = null
var delay_camera = 0.2
var trapped = true
var level_parent = null
var ghost = preload("res://scenes/enemy_ghost.tscn")
var q = -1

func _ready():
	add_to_group("prisoners")
	$sprite.play()
	$display.visible = false

func _physics_process(delta):
	if !active and opened:
		if player:
			if delay_camera > 0:
				delay_camera -= 1 * delta
				if delay_camera <= 0:
					player.dont_camera = false
	
	if active and !opened:
		if Input.is_action_just_pressed("up"):
			Global.play_sound(Global.InteractSFX)
			trapped = false
			opened = true
			active = false
			Global.emit(global_position, 5)
			get_item()
			
func get_item():
	Global.prisoner_counter -= 1
	Global.map_obj.notify_prisoner_done(q)
	$display/back/sprite.visible = false
	$sprite.animation = "default"

func _on_body_entered(body):
	if !opened and body.is_in_group("players") and !body.is_in_group("prisoners"):
		body.dont_camera = true
		$display.visible = true
		var center = Global.shaker_obj.camera.get_screen_center_position()
		$display.global_position = center
		active = true
		player = body

func _on_body_exited(body):
	if body.is_in_group("players") and !body.is_in_group("prisoners"):
		body.dont_camera = false
		$display.visible = false
		active = false
		body.dont_camera = false
