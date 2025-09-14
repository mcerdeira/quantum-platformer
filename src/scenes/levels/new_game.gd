extends Node2D
var new_game = false
var f_exists = false
var playing_back = false

func _ready() -> void:
	#Resetear el distort por si quedo del juego
	Global.load_game()
	if Global.CHROM_FX and is_instance_valid(Global.CHROM_FX):
		Global.CHROM_FX.resetdistor()
	
	f_exists = FileAccess.file_exists("user://savegame.save")
	if f_exists:
		var date = FileAccess.get_modified_time("user://savegame.save")
		var dict = Time.get_datetime_dict_from_unix_time(date)
		var fecha_str = "%02d/%02d/%04d %02d:%02d" % [
			dict.day, dict.month, dict.year,
			dict.hour, dict.minute
		]
		$saved.text = "Partida guardada\n" + fecha_str
		save_pressed()
	else:
		$saved.text = "..."
		$saved.disabled = true
		new_pressed()
		
func initial_focus():
	visible = true
	$btn_start.grab_focus()
		
func _physics_process(delta: float) -> void:
	if scale.x == 1:
		if Input.is_action_just_pressed("quit_soft"):
			salir()

func _on_btn_volver_pressed() -> void:
	salir()
	
func release_all_focus():
	get_viewport().gui_release_focus()
	
func salir():
	Global.play_sound(Global.InteractSFX)
	get_tree().paused = false
	playing_back = true
	$AnimationPlayer.play_backwards("new_animation")
	$"../PStart".visible = true
	release_all_focus()

func _on_saved_pressed() -> void:
	Global.play_sound(Global.InteractSFX)
	save_pressed()

func save_pressed():
	new_game = false
	var idx = 1
	if Global.SALAMANDER_STATUS:
		idx = 4
	elif  Global.MERMAID_STATUS:
		idx = 3
	elif Global.TOMB_STATUS:
		idx = 2
	elif Global.LEAF_STATUS:
		idx = 1
				
	var dead = "💀"
	var alive = "❤️"
		
	var text = "Progreso: " + Global.Terminals[idx].name + "\n\n"
	text += "Monedas 🪙:" + str(Global.Gold) + "\n\n"
	text += "1. 👹" + (dead if Global.ARTIFACT_PER_LEVEL[1] else alive) + "\n"
	text += "2. 👹" + (dead if Global.ARTIFACT_PER_LEVEL[2] else alive) + "\n"
	text += "3. 👹" + (dead if Global.ARTIFACT_PER_LEVEL[3] else alive) + "\n"
	text += "4. 👹" + (dead if Global.ARTIFACT_PER_LEVEL[4] else alive) + "\n" + "\n"
	text += "Muertes 💀: " + str(Global.DEATHS)
	
	$lbl_status.text = text
	
func new_pressed():
	new_game = true
	$lbl_status.text = "Iniciar partida nueva.\nPERDERAS TODO EL PROGRESO."

func _on_new_pressed() -> void:
	Global.play_sound(Global.InteractSFX)
	new_pressed()

func _on_btn_start_pressed() -> void:
	Global.play_sound(Global.InteractSFX)
	$saved.disabled = true
	$new.disabled = true
	$btn_volver.disabled = true
	$btn_start.disabled = true
	Global.play_sound(Global.Item3DSFX)
	$Timer.start()

func _on_timer_timeout() -> void:
	get_tree().paused = false
	if new_game:
		Global.ARTIFACT_PER_LEVEL = [false, false, false, false, false]
		Global.perks_equiped = [null, null, null, null, null, null, null]
		Global.CurrentLevel = 0
		Global.Gold = 0
		Global.GoldDonation = 0
		Global.first_time = true
		Global.FirstDeath = true
		Global.erase_game()
		Global.init_game()
		
	Global.scene_next()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if playing_back:
		playing_back = false
		visible = false
	else:
		initial_focus()
