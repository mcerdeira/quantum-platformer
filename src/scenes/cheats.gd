extends Node2D

func _ready():
	terminal_trad()

func _physics_process(_delta):
	if Input.is_action_just_pressed("cheat"):
		visible = !visible
		if visible:
			if special_rooms():
				get_parent().visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			if special_rooms():
				get_parent().visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			
func special_rooms():
	return Global.CurrentState == Global.GameStates.HOME or Global.CurrentState == Global.GameStates.FALLING or Global.CurrentState == Global.GameStates.OUTSIDE

func _on_bnt_coin_pressed():
	Global.get_item(Global.coin, 1)

func _on_bnt_muffin_pressed():
	Global.get_item(Global.muffin)

func _on_bnt_clone_pressed():
	Global.get_item(Global.clone)

func _on_bnt_teleport_pressed():
	Global.get_item(Global.teleport)

func _on_bnt_bomb_pressed():
	Global.get_item(Global.bomb)

func _on_bnt_smoke_pressed():
	Global.get_item(Global.smoke_bomb)

func _on_bnt_plant_pressed():
	Global.get_item(Global.plant)

func _on_bnt_spring_pressed():
	Global.get_item(Global.spring)

func _on_bnt_level_pressed():
	Global.get_item(Global.coin, 10)
	Global.donate(10)

func _on_btn_nextscene_pressed():
	if $txt_terminal.text == "":
		Global.scene_next()
	else:
		Global.scene_next(int($txt_terminal.text), $chk_boss.button_pressed)

func _on_btn_reset_pressed():
	Global.CurrentLevel = 0
	Global.Gold = 0
	Global.GoldDonation = 0
	Global.first_time = true
	Global.FirstDeath = true
	Global.erase_game()
	Global.CurrentState = Global.GameStates.HOME
	Global.Fader.fade_in()
	get_tree().reload_current_scene()

func terminal_trad():
	if $txt_terminal.text != "" and int($txt_terminal.text) < Global.Terminals.size():
		$lbl_terminal.text = Global.Terminals[int($txt_terminal.text)].name
	else:
		$lbl_terminal.text = ""

func _on_txt_terminal_text_changed():
	terminal_trad()
