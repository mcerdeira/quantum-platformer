extends Node2D
var focus_exit = false

func _ready():
	visible = false

func _physics_process(delta):
	if Global.CurrentState != Global.GameStates.TITLE and !Global.TunnelTerminalNumber:
		if visible:
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
	$btn_resumir.grab_focus()
	focus_exit = false
	visible = !visible
	if visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = visible
