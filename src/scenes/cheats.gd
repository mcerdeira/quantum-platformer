extends Node2D

func _physics_process(delta):
	if Input.is_action_just_pressed("cheat"):
		visible = !visible
		if visible:
			if Global.CurrentState == Global.GameStates.HOME or Global.CurrentState == Global.GameStates.OUTSIDE:
				get_parent().visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			if Global.CurrentState == Global.GameStates.HOME or Global.CurrentState == Global.GameStates.OUTSIDE:
				get_parent().visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

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
	Global.scene_next()

func _on_btn_reset_pressed():
	Global.CurrentLevel = 0
	Global.Gold = 0
	Global.GoldDonation = 0
	
	Global.CurrentState = Global.GameStates.HOME
	Global.Fader.fade_in()
	get_tree().reload_current_scene()
