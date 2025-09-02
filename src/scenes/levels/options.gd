extends Node2D


func _ready() -> void:
	$pause_color2/lbl_lenguaje2/chk.button_pressed = Global.FULLSCREEN
	if Global.FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_btn_salir_pressed() -> void:
	Global.play_sound(Global.InteractSFX)
	$btn_salir.release_focus()
	get_tree().paused = false
	$AnimationPlayer.play_backwards("new_animation")
	$"../PStart".visible = true
	Global.save_options()
	
func _on_chk_pressed() -> void:
	Global.FULLSCREEN = $pause_color2/lbl_lenguaje2/chk.button_pressed
	if Global.FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
