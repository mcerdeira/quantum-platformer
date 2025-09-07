extends Node2D
var focus_exit = false
var paused = false

func _ready():
	paused = false
	visible = false
	Global.pauseobj = self

func _physics_process(_delta):
	if Global.CurrentState != Global.GameStates.TITLE and !Global.TunnelTerminalNumber:
		if paused:
			if Input.is_action_just_pressed("left"):
				$btn_salir.grab_focus()
				focus_exit = true
				
			if Input.is_action_just_pressed("right"):
				$btn_resumir.grab_focus()
				focus_exit = false
				
			if Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("shoot"):
				if focus_exit:
					exit()
				else:
					resume()
		
		if Input.is_action_just_pressed("quit"):
			if !$"../VideoContainer".visible and !$"../../GlobalCamera/BinocularCircle".visible and !Global.GAMEOVER:
				pause_unpause()
			
func exit():
	if Global.CHROM_FX:
		Global.CHROM_FX.resetdistor()
	Global.save_game()
	Music.stop()
	Bees.stop()
	Ambience.stop()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)
	Global.CurrentState = Global.GameStates.TITLE
	visible = false
	get_tree().paused = visible
	get_tree().reload_current_scene()

func _on_btn_salir_pressed():
	exit()
	
func resume():
	pause_unpause()

func _on_btn_resumir_pressed():
	resume()

func pause_unpause():
	if Global.CurrentState == Global.GameStates.PRE_ENDING:
		return
	
	if Global.PauseStop:
		Global.PauseStop = false
		return
	
	Global.play_sound(Global.PauseSFX)
	$btn_resumir.grab_focus()
	focus_exit = false
	paused = !paused

	if paused:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -20)
		
		$pause_color2/gun_slot0/lbl_stock.text = "x0"
		$pause_color2/gun_slot1/lbl_stock.text = "x0"
		$pause_color2/gun_slot2/lbl_stock.text = "x0"
		$pause_color2/gun_slot3/lbl_stock.text = "x0"
		$pause_color2/gun_slot4/lbl_stock.text = "x0"
		$pause_color2/gun_slot5/lbl_stock.text = "x0"
		$pause_color2/gun_slot6/lbl_stock.text = "x0"
		$pause_color2/gun_slot7/lbl_stock.text = "x" + str(Global.Gold)
		
		
		for i in range(Global.gunz_equiped.size()):
			var name = Global.gunz_equiped[i].name
			if name != "none":
				var c = Global.gunz_equiped[i].stock
				if name == "muffin":
					$pause_color2/gun_slot0/lbl_stock.text = "x" + str(c)
				elif name == "bomb":
					$pause_color2/gun_slot1/lbl_stock.text = "x" + str(c)
				elif name == "smoke":
					$pause_color2/gun_slot2/lbl_stock.text = "x" + str(c)
				elif name == "plant":
					$pause_color2/gun_slot3/lbl_stock.text = "x" + str(c)
				elif name == "clone":
					$pause_color2/gun_slot4/lbl_stock.text = "x" + str(c)
				elif name == "teleport":
					$pause_color2/gun_slot5/lbl_stock.text = "x" + str(c)
				elif name == "spring":
					$pause_color2/gun_slot6/lbl_stock.text = "x" + str(c)
		
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)
	
	if paused:
		$"../../Pause".visible = true
		visible = true
		$AnimationPlayer.play("new_animation")
	else:
		$AnimationPlayer.play_backwards("new_animation")
		$"../../Pause".visible = false
		
	if paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
	get_tree().paused = paused

func _on_animation_player_animation_finished(_anim_name):
	if !paused:
		visible = false 
