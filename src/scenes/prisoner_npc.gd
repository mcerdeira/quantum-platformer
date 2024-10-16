extends Area2D
var active = false
var opened = false
var player = null
var delay_camera = 0.2
var current_message = ""
var ttl = 0
var dialog_sfx = null
@export var boss_1_npc = false
var end_ttl = 5

func _physics_process(delta):
	if boss_1_npc:
		$Timer.stop()
		$Computer.animation = "boss1"
		$Computer/cry.animation = "boss1"
	
	$back2.visible = $back.visible 
	if !active and opened:
		if !current_message:
			end_ttl -= 1 * delta
			if end_ttl <= 0:
				if boss_1_npc and Global.CurrentState != Global.GameStates.SHOP:
					Global.scene_next(Global.TerminalNumber, false)
		
		if player:
			if delay_camera > 0:
				delay_camera -= 1 * delta
				if delay_camera <= 0:
					player.dont_camera = false
					
	if current_message:
		ttl -= 1 * delta
		if ttl <= 0:
			ttl = 0.05
			$back/lbl_item.text += current_message.substr(0, 1)
			current_message = current_message.substr(1, current_message.length() - 1)
			if !current_message:
				Global.kill(dialog_sfx)
				Global.player_obj.dont_camera = false
				active = false
				await get_tree().create_timer(1.3).timeout
				$back.visible = false
	
	if active and !opened:
		if Input.is_action_just_pressed("up"):
			Global.play_sound(Global.InteractSFX)
			opened = true
			active = false
			Global.emit(global_position, 5)
			if boss_1_npc:
				$Computer.animation = "boss1"
				$Computer/cry.animation = "boss1"
				if Global.CurrentState == Global.GameStates.SHOP:
					$back/sprite.animation = "shop"
				else:
					$back/sprite.animation = "boss1"
					$back/sprite.scale.x = 0.1
					$back/sprite.scale.y = 0.1
			else:
				$back/sprite.animation = "prisoner"
				
			$back/sprite.play()
			dialog_sfx = Global.play_sound(Global.DialogSFX)
			if boss_1_npc:
				if Global.CurrentState == Global.GameStates.SHOP:
					current_message = "¡Gracias de nuevo! Pude abrir la tienda y te doy un descuento por ser vos..."
				else:
					current_message = "¡GRACIAS! El bicho este horrible me había comido... pero acá no está tu perro..."
			else:
				current_message = "¡La  G R U T A  se llevo a mis amigos y a tu perro!"
			$back/lbl_item.text = ""
			$back/arrows.visible = false

func _on_body_entered(body):
	if !opened and body.is_in_group("players") and !body.is_in_group("prisoners"):
		body.dont_camera = true
		$back.visible = true
		active = true
		player = body

func _on_body_exited(body):
	if body.is_in_group("players") and !body.is_in_group("prisoners"):
		if !opened or (opened and current_message == ""):
			body.dont_camera = false
			$back.visible = false
			active = false

func _on_timer_timeout():
	if !boss_1_npc:
		$Timer.wait_time = Global.pick_random([2, 3, 4])
		var options = {"pitch_scale": Global.pick_random([1, 0.7, 1.1])}
		Global.play_sound(Global.CryingSFX, options, global_position)
