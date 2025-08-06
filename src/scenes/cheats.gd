extends Node2D
var parent_visible = null

func _ready():
	terminal_trad()
	for i in range(1, 5):
		var chk = get_node("check" + str(i))
		chk.button_pressed = Global.ARTIFACT_PER_LEVEL[i]

func _physics_process(_delta):
	if Global.TerminalNumber == -1:
		$Label3.text = "-1"
	else:
		$Label3.text = Global.Terminals[Global.TerminalNumber].name
	
	var boss_room = ""
	if Global.BOSS_ROOM:
		boss_room = "- BOSS!"
	
	$Label5.text = Global.GameStates.keys()[Global.CurrentState] + boss_room
	
	if Input.is_action_just_pressed("cheat"):
		visible = !visible
		if visible and parent_visible == null:
			if !get_parent().visible:
				parent_visible = false
			else:
				parent_visible = true
				
		if parent_visible == false:
			get_parent().visible = visible
		
		if visible:
			if special_rooms():
				get_parent().visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			if special_rooms():
				get_parent().visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			
func special_rooms():
	return Global.CurrentState == Global.GameStates.SHOP or Global.CurrentState == Global.GameStates.DEMO or Global.CurrentState == Global.GameStates.HOME or Global.CurrentState == Global.GameStates.FALLING or Global.CurrentState == Global.GameStates.OUTSIDE

func _on_bnt_coin_pressed():
	var coins = int($txt_coin.text)
	Global.get_item(Global.coin, coins)

func _on_bnt_muffin_pressed():
	Global.get_item(Global.muffin)
	Global.player_obj.refresh_item()

func _on_bnt_clone_pressed():
	Global.get_item(Global.clone)
	Global.player_obj.refresh_item()

func _on_bnt_teleport_pressed():
	Global.get_item(Global.teleport)
	Global.player_obj.refresh_item()

func _on_bnt_bomb_pressed():
	Global.get_item(Global.bomb)
	Global.player_obj.refresh_item()

func _on_bnt_smoke_pressed():
	Global.get_item(Global.smoke_bomb)
	Global.player_obj.refresh_item()

func _on_bnt_plant_pressed():
	Global.get_item(Global.plant)
	Global.player_obj.refresh_item()

func _on_bnt_spring_pressed():
	Global.get_item(Global.spring)
	Global.player_obj.refresh_item()

func _on_bnt_level_pressed():
	Global.get_item(Global.coin, 10)
	Global.donate(10)

func _on_btn_nextscene_pressed():
	if $txt_terminal.text == "":
		Global.scene_next()
	else:
		Global.scene_next(int($txt_terminal.text), $chk_boss.button_pressed)

func _on_btn_reset_pressed():
	Global.ARTIFACT_PER_LEVEL = [false, false, false, false, false]
	Global.perks_equiped = [null, null, null, null, null, null, null]
	Global.CurrentLevel = 0
	Global.Gold = 0
	Global.GoldDonation = 0
	Global.first_time = true
	Global.FirstDeath = true
	Global.erase_game()
	Global.init_game()
	Global.CurrentState = Global.GameStates.TITLE
	Global.Fader.fade_in()
	get_tree().reload_current_scene()

func terminal_trad():
	if $txt_terminal.text != "" and int($txt_terminal.text) < Global.Terminals.size():
		$lbl_terminal.text = Global.Terminals[int($txt_terminal.text)].name
	else:
		$lbl_terminal.text = ""

func _on_txt_terminal_text_changed():
	terminal_trad()

func _on_btn_liberate_pressed():
	var targets = get_tree().get_nodes_in_group("prisoners")
	if targets.size() > 0:
		for t in targets:
			t.liberate()

func _on_btn_killboss_pressed():
	var bosses = get_tree().get_nodes_in_group("bosses")
	for b in bosses:
		b.force_kill()
		
	bosses = get_tree().get_nodes_in_group("boss_persecution")
	for b in bosses:
		b.force_kill()

func _on_btn_demoroom_pressed():
	Global.CurrentState = Global.GameStates.DEMO
	get_tree().reload_current_scene()

func _on_btn_shop_pressed():
	Global.CurrentState = Global.GameStates.SHOP
	get_tree().reload_current_scene()

func _on_btn_challenge_pressed():
	Global.CurrentState = Global.GameStates.CHALLENGE
	get_tree().reload_current_scene()

func _on_check_1_pressed() -> void:
	Global.ARTIFACT_PER_LEVEL[1] = $check1.button_pressed

func _on_check_2_pressed() -> void:
	Global.ARTIFACT_PER_LEVEL[2] = $check2.button_pressed

func _on_check_3_pressed() -> void:
	Global.ARTIFACT_PER_LEVEL[3] = $check3.button_pressed

func _on_check_4_pressed() -> void:
	Global.ARTIFACT_PER_LEVEL[4] = $check4.button_pressed

func _on_btn_boat_pressed() -> void:
	Global.BoatUnlocked = true
	Global.BoatObj.activate()
