extends Node2D
var updating_slider = true

func _ready() -> void:
	$pause_color2/lbl_lenguaje3/chk.button_pressed = Global.ReducirDestellos
	$pause_color2/lbl_lenguaje6/chk.button_pressed = Global.Aracnofobia
	updating_slider = true
	$pause_color2/lbl_lenguaje2/chk.button_pressed = Global.FULLSCREEN
	Global.apply_fullscreen()
	$pause_color2/lbl_lenguaje4/musicsl.value = Global.MusicVolume
	Global.apply_music_volume()
	$pause_color2/lbl_lenguaje5/sfxsl.value = Global.SfxVolume
	Global.apply_sfx_volume()
	updating_slider = false
	
func _on_btn_salir_pressed() -> void:
	Global.play_sound(Global.InteractSFX)
	$btn_salir.release_focus()
	get_tree().paused = false
	$AnimationPlayer.play_backwards("new_animation")
	$"../PStart".visible = true
	Global.save_options()
	
func _on_chk_pressed() -> void:
	Global.FULLSCREEN = $pause_color2/lbl_lenguaje2/chk.button_pressed
	Global.apply_fullscreen()

func _on_musicsl_value_changed(value: float) -> void:
	Global.MusicVolume = $pause_color2/lbl_lenguaje4/musicsl.value
	Global.apply_music_volume()

func _on_sfxsl_value_changed(value: float) -> void:
	if !updating_slider:
		Global.SfxVolume = $pause_color2/lbl_lenguaje5/sfxsl.value
		Global.apply_sfx_volume()
		Global.play_sound(Global.InteractSFX)
