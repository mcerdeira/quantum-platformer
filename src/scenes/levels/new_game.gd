extends Node2D

func _ready() -> void:
	var f_exists = FileAccess.file_exists("user://savegame.save")
	if f_exists:
		var date = FileAccess.get_modified_time("user://savegame.save")
		var dict = Time.get_datetime_dict_from_unix_time(date)
		var fecha_str = "%02d/%02d/%04d %02d:%02d" % [
			dict.day, dict.month, dict.year,
			dict.hour, dict.minute
		]
		
		$saved.text = "Partida guardada\n" + fecha_str
	else:
		$saved.text = "..."

func _on_btn_volver_pressed() -> void:
	Global.play_sound(Global.InteractSFX)
	$btn_volver.release_focus()
	get_tree().paused = false
	$AnimationPlayer.play_backwards("new_animation")
	$"../PStart".visible = true
