extends Node2D
var focus_exit = false
var paused = false

func _ready():
	paused = false
	visible = false

func _physics_process(delta):
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
			pause_unpause()
			
func exit():
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
	Global.play_sound(Global.PauseSFX)
	$btn_resumir.grab_focus()
	focus_exit = false
	paused = !paused

	if paused:
		Music.pause()
		Ambience.pause()
	else:
		Music.resume()
		Ambience.resume()
	
	if paused:
		visible = true
		$AnimationPlayer.play("new_animation")
	else:
		$AnimationPlayer.play_backwards("new_animation")
		
	if paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
	await get_tree().create_timer(0.5).timeout
	get_tree().paused = paused

func _on_animation_player_animation_finished(anim_name):
	if !paused:
		visible = false 
