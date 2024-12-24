extends Node2D
@export var platform : StaticBody2D = null
var opened = false
var active = false

func _physics_process(delta):
	if active and opened:
		if Input.is_action_pressed("left"):
			platform.rotation_degrees -= 100 * delta
			$sprite.rotation_degrees -= 100 * delta
			$display.visible = false
		elif Input.is_action_pressed("right"):
			platform.rotation_degrees += 100 * delta
			$sprite.rotation_degrees += 100 * delta
			$display.visible = false
		
		if Input.is_action_just_pressed("up"):
			Global.play_sound(Global.InteractSFX)
			$display/back/lbl_item.text = "== VALVULA =="
			opened = false
			Global.player_obj.show_eyes()
			Global.player_obj.locked_ctrls = false
	
	elif active and !opened:
		if Input.is_action_just_pressed("up"):
			Global.play_sound(Global.InteractSFX)
			$display/back/lbl_item.text = "<-- IZQUIERDA DERECHA -->"
			opened = true
			Global.player_obj.hide_eyes()
			Global.player_obj.locked_ctrls = true
			Global.emit(global_position, 5)

func _on_area_2d_body_entered(body):
	if !opened and body.is_in_group("players") and !body.is_in_group("prisoners"):
		active = true
		body.dont_camera = true
		$display.visible = true
		var center = Global.shaker_obj.camera.get_screen_center_position()
		$display.global_position = center

func _on_area_2d_body_exited(body):
	if body.is_in_group("players") and !body.is_in_group("prisoners"):
		active = false
		body.dont_camera = false
		$display.visible = false
		body.dont_camera = false
