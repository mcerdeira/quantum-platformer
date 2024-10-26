extends Area2D
var current_item = null
var opened = false
var active = false
var player = null
var delay_camera = 0.2
var ttl = 0

func _physics_process(delta):
	if ttl > 0:
		ttl -= 1 * delta
		if ttl <= 0:
			resetsign()
		return
		
	$display.visible = active
	
	if !active and opened:
		if player:
			if delay_camera > 0:
				delay_camera -= 1 * delta
				if delay_camera <= 0:
					player.dont_camera = false
	
	if active and !opened:
		$display.visible = true
		if Input.is_action_just_pressed("up"):
			Global.play_sound(Global.ChestOpenSFX)
			Global.emit(global_position, 5)
			current_item = Global.pick_random(Global.gunz_objs_prob_nocoin)
			if Global.buy_item(current_item.name.to_upper(), 1):
				var show_video = false
				if current_item.name == "smoke" and Global.first_time_smoke:
					Global.first_time_smoke = false
					show_video = true
				
				if current_item.name == "plant" and Global.first_time_plant:
					Global.first_time_plant = false
					show_video = true
					
				if current_item.name == "clone" and Global.first_time_clone:
					Global.first_time_clone = false
					show_video = true
					
				if current_item.name == "teleport" and Global.first_time_teleport:
					Global.first_time_teleport = false
					show_video = true
					
				if current_item.name == "muffin" and Global.first_time_muffin:
					Global.first_time_muffin = false
					show_video = true
					
				if current_item.name == "bomb" and Global.first_time_bomb:
					Global.first_time_bomb = false
					show_video = true
					
				if current_item.name == "spring" and Global.first_time_spring:
					Global.first_time_spring = false
					show_video = true
					
				if show_video:
					Global.video_tutorial.play(current_item)
					ttl = 0.0
					resetsign()
				else:
					$display/back/lbl_item.text = "== " + current_item.friendly_name.to_upper() + " ==" + "\n" + current_item.description
					$display/back/sprite.animation = current_item.name
					$display/back/arrows.animation = "empty"
					Global.play_sound(Global.InteractSFX)
					ttl = 1.1
			else:
				$display/back/lbl_item.text = "== POBREZA ==" + "\nNo te quedan mas monedas =(" 
				$display/back/sprite.animation = "no-coin"
				$display/back/arrows.animation = "empty"
				ttl = 1.1
					
			active = true
			opened = false 

func _on_body_entered(body):
	if !opened and body.is_in_group("players") and !body.is_in_group("prisoners"):
		body.dont_camera = true
		$display.visible = true
		var center = Global.shaker_obj.camera.get_screen_center_position()
		$display.global_position = center
		active = true
		player = body
		resetsign()
		
func resetsign():
	$display/back/lbl_item.text = "==GACHAPON==\nObtener un item al azar por 1 moneda."
	$display/back/sprite.animation = "coin"
	$display/back/arrows.animation = "default"

func _on_body_exited(body):
	if body.is_in_group("players") and !body.is_in_group("prisoners"):
		body.dont_camera = false
		$display.visible = false
		active = false
		opened = false
		body.dont_camera = false
