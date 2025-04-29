extends Node2D
var particle = preload("res://scenes/particle2.tscn")
var player_placed = false
var gameover_ttl_total = 3
var gameover_ttl = gameover_ttl_total

var room_title = preload("res://scenes/levels/room_title.tscn") 
var room_home = preload("res://scenes/levels/room_house.tscn")
var room_outside = preload("res://scenes/levels/room_outside.tscn")
var room_falling = preload("res://scenes/levels/room_falling.tscn")
var room_overworld = preload("res://scenes/levels/room_overworld.tscn")
var room_tunnel = preload("res://scenes/levels/room_tunnel.tscn")
var room_demo = preload("res://scenes/levels/room_demo.tscn")
var room_shop = preload("res://scenes/levels/room_shop.tscn")

var rooms_bottom_dragon = [
	preload("res://scenes/levels/dragon/room_bottom_dragon.tscn"),
	preload("res://scenes/levels/dragon/room_bottom_dragon1.tscn")
]
var rooms_middle_dragon = [
	preload("res://scenes/levels/dragon/room_middle_dragon.tscn")
]
var rooms_top_dragon = [
	preload("res://scenes/levels/dragon/room_top_dragon.tscn")
]

var rooms_bottom_mermaid = [
	preload("res://scenes/levels/mermaid/room_bottom_mermaid.tscn"),
	preload("res://scenes/levels/mermaid/room_bottom_mermaid2.tscn"),
]
var rooms_middle_mermaid = [
	preload("res://scenes/levels/mermaid/room_middle_mermaid.tscn")
]
var rooms_top_mermaid = [
	preload("res://scenes/levels/mermaid/room_top_mermaid.tscn")
]

var rooms_bottom_tomb = [
	preload("res://scenes/levels/tomb/room_bottom_tomb.tscn")
]
var rooms_middle_tomb = [
	preload("res://scenes/levels/tomb/room_middle_tomb.tscn"),
]

var rooms_middle_tomb2 = [
	preload("res://scenes/levels/tomb/room_middle_tomb_b.tscn"),
]

var rooms_top_tomb = [
	preload("res://scenes/levels/tomb/room_top_tomb.tscn")
]

var rooms_top = [
	preload("res://scenes/levels/leaf/room_top1.tscn"),
	preload("res://scenes/levels/leaf/room_top2.tscn")
]
var rooms_middle1 = [
	preload("res://scenes/levels/leaf/room_middle1.tscn")
]
var rooms_middle2 = [
	preload("res://scenes/levels/leaf/room_middle2.tscn")
]
var rooms_bottom = [
	preload("res://scenes/levels/leaf/room_bottom0.tscn"),
	preload("res://scenes/levels/leaf/room_bottom1.tscn")
]

var rooms_bosses = [
	null,
	[preload("res://scenes/levels/leaf/room_boss.tscn")],
	[preload("res://scenes/levels/tomb/room_boss.tscn")],
	[preload("res://scenes/levels/mermaid/room_boss.tscn")],
	[preload("res://scenes/levels/dragon/room_boss.tscn")],
]

var rooms_challenge_horizontal = [
	preload("res://scenes/levels/challenge/room_challenge_horizontal1.tscn"),
	preload("res://scenes/levels/challenge/room_challenge_horizontal2.tscn"),
	preload("res://scenes/levels/challenge/room_challenge_horizontal3.tscn"),
]

var list_rooms_top = [
	null,
	rooms_top,
	rooms_top_tomb,
	rooms_top_mermaid,
	rooms_top_dragon
]
var list_rooms_middle1 = [
	null,
	rooms_middle1,
	rooms_middle_tomb,
	rooms_middle_mermaid,
	rooms_middle_dragon
]
var list_rooms_middle2  = [
	null,
	rooms_middle2,
	rooms_middle_tomb2, #2 #TODO
	rooms_middle_mermaid,#2
	rooms_middle_dragon#2
]
var list_rooms_bottom  = [
	null,
	rooms_bottom,
	rooms_bottom_tomb,
	rooms_bottom_mermaid,
	rooms_bottom_dragon
]

func generate_fixed_level(room, visible_hud):
	var q = 1
	$frame.queue_free()
	var r = room.instantiate()
	r.global_position =  Vector2.ZERO
	r.q = q
	add_child(r)
	$CanvasLayer/Control.visible = visible_hud
	
func generate_challenge_horizontal():
	var player_room = Vector2(randi() % 4, 0)
	var door_room = Vector2(randi() % 4, randi() % 4)
	var size = Vector2(1152, 640) #TODO: Cambiar
	var room_pos = Vector2.ZERO
	var total_w = 8
	var room = null
	var q = 1

	player_room = Vector2(0, 0)
	
	$frame.queue_free()

	for w in range(total_w):
		room = Global.pick_random(rooms_challenge_horizontal)
		var r = room.instantiate()
		r.global_position = room_pos
		r.q = q
		q += 1
		
		room_pos.x += size.x
		
		if w == 0:
			r.deletelimit2()
			r.delete_door()
		elif w == total_w - 1:
			r.delete_player()
			r.delete_bicho()
			r.deletelimit1()
		else:
			r.delete_player()
			r.delete_bicho()
			r.deletelimit1()
			r.deletelimit2()
			r.delete_door()
			
		add_child(r)
		
func generate_level():
	var player_room = Vector2(randi() % 4, 0)
	var door_room = Vector2(randi() % 4, randi() % 4)
	var size = Vector2(1152, 640) #TODO: Cambiar
	var room_pos = Vector2.ZERO
	var total_h = 4
	var total_w = 4
	var room = null
	var q = 1
	var prisonercount = 0
	var _rooms_top = null
	var _rooms_middle1 = null
	var _rooms_middle2 = null
	var _rooms_bottom = null
	if Global.BOSS_ROOM:
		Global.reset_gunz()
		$frame.queue_free()
		$CanvasLayer/Control.visible = false
		prisonercount = 0
		_rooms_top = rooms_bosses[Global.TerminalNumber]
		_rooms_middle1 = null
		_rooms_middle2 = null
		_rooms_bottom = null
		player_room = Vector2(0, 0)
		total_h = 1
		total_w = 1
	else:
		prisonercount = Global.Terminals[Global.TerminalNumber].prisoners
		_rooms_top = list_rooms_top[Global.TerminalNumber]
		_rooms_middle1 = list_rooms_middle1[Global.TerminalNumber]
		_rooms_middle2 = list_rooms_middle2[Global.TerminalNumber]
		_rooms_bottom = list_rooms_bottom[Global.TerminalNumber]

	for h in range(total_h):
		for w in range(total_w):
			room = null
			
			if h == 0:
				if _rooms_top:
					room = Global.pick_random(_rooms_top)
					
			if h == 1:
				if _rooms_middle1:
					room = Global.pick_random(_rooms_middle1)
				
			if h == 2:
				if _rooms_middle2:
					room = Global.pick_random(_rooms_middle2)
			
			if h == 3:
				if _rooms_bottom:
					if Global.TerminalNumber == Global.TerminalsEnum.SALAMANDER:
						if w == 3:
							room = _rooms_bottom[0]
						else:
							room = _rooms_bottom[1]
					else:
						room = Global.pick_random(_rooms_bottom)
				
			if room:
				var r = room.instantiate()
				r.global_position = room_pos
				r.q = q
				q += 1
				
				room_pos.x += size.x
				if player_room != Vector2(w, h):
					r.delete_player()
					
				if door_room != Vector2(w, h):
					if !Global.BOSS_ROOM:
						r.delete_door()
				else:
					if !Global.BOSS_ROOM:
						r.assign_door(Global.TerminalNumber)
				
				add_child(r)
		
		room_pos.y += size.y
		room_pos.x = 0
		
	if !Global.BOSS_ROOM:
		var special_doors = get_tree().get_nodes_in_group("special_doors")
		while special_doors.size() > 1:
			special_doors.shuffle()
			var t = special_doors.pop_front()
			t.queue_free()
			
		var color_buttons = get_tree().get_nodes_in_group("color_button")
		while color_buttons.size() > 1:
			color_buttons.shuffle()
			var t = color_buttons.pop_front()
			t.queue_free()

		var prisoner_markers = get_tree().get_nodes_in_group("prisoner_markers")
		while prisoner_markers.size() > prisonercount:
			prisoner_markers.shuffle()
			var pm = prisoner_markers.pop_front()
			pm.kill()
		
		for _pm in prisoner_markers:
			if !_pm.dead:
				_pm.done = true
		
func _ready():
	var particles2 = get_tree().get_nodes_in_group("particles2")
	for p in particles2:
		p.visible = false
		p.queue_free()
	
	Global.prisoner_counter = 0
	Global.prisoner_total = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Bees.stop()
	
	if Global.CurrentState == Global.GameStates.RANDOMLEVEL:
		if !Global.TunnelTerminalNumber and !Global.BOSS_ROOM and randi() % 3 == 0:
			Global.OverWorldFromGameOver = false
			Global.TunnelTerminalNumber = true
			generate_fixed_level(room_tunnel, false)
		else:
			if Global.TerminalNumber == Global.TerminalsEnum.LEAF:
				Ambience.play(Global.CaveAmbienceSFX)
			elif Global.TerminalNumber == Global.TerminalsEnum.TOMB:
				Ambience.play(Global.TombAmbienceSFX)
			elif Global.TerminalNumber == Global.TerminalsEnum.MERMAID:
				Ambience.play(Global.RainAmbienceSFX)	
			elif Global.TerminalNumber == Global.TerminalsEnum.SALAMANDER:
				Ambience.play(Global.FireAmbienceSFX)	
				
			Global.TunnelTerminalNumber = false
			generate_level()
	
	if Global.CurrentState == Global.GameStates.DEMO:
		generate_fixed_level(room_demo, false)
	if Global.CurrentState == Global.GameStates.SHOP:
		Music.play(Global.ShopTheme)
		Ambience.play(Global.HouseAmbienceSFX)
		generate_fixed_level(room_shop, true)
	if Global.CurrentState == Global.GameStates.CHALLENGE:
		Music.play(Global.SpecialLevelTheme)
		Ambience.stop()
		Bees.stop()
		generate_challenge_horizontal()
	if Global.CurrentState == Global.GameStates.TITLE:
		Music.play(Global.MainTheme)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		generate_fixed_level(room_title, false)
	if Global.CurrentState == Global.GameStates.HOME:
		Music.play(Global.MainThemeShort)
		Ambience.play(Global.HouseAmbienceSFX)
		generate_fixed_level(room_home, false)
	if Global.CurrentState == Global.GameStates.OUTSIDE:
		Music.stop()
		Ambience.play(Global.ExteriorAmbienceSFX)
		generate_fixed_level(room_outside, false)
	if Global.CurrentState == Global.GameStates.FALLING:
		Music.stop()
		Ambience.play(Global.FallingAmbienceSFX)
		generate_fixed_level(room_falling, false)
	if Global.CurrentState == Global.GameStates.OVERWORLD:
		if !Global.BOSS_ROOM:
			Music.play(Global.MainThemeShort)
		else:
			Music.stop()
			
		Ambience.play(Global.CaveAmbienceSFX)
		generate_fixed_level(room_overworld, true)
		
	Global.GizmoWatcher = self
	setHUD(false, true)

func setHUD(only_gold = false, first_time = false):
	var lbl_coin = get_node("CanvasLayer/Control/coin_slot2/lbl_stock")
	lbl_coin.text = "x" + str(Global.Gold)
	
	if !Global.BOSS_ROOM:
		for i in range(1, 7):
			var perk = get_node("CanvasLayer/Control/perks" + str(i))
			if Global.perks_equiped[i] != null:
				perk.visible = true
	
	if only_gold:
		return
		
	$CanvasLayer/Control/gun_slot0/cosito1.visible = false
	$CanvasLayer/Control/gun_slot0/cosito2.visible = false
		
	if Global.gunz_equiped.size() > 0:
		$CanvasLayer/Control/gun_slot0/cosito1.visible = Global.gunz_equiped.size() > 1
		$CanvasLayer/Control/gun_slot0/cosito2.visible = $CanvasLayer/Control/gun_slot0/cosito1.visible
		
		var slot = get_node("CanvasLayer/Control/gun_slot0")
		slot.animation = Global.gunz_equiped[Global.gunz_index].name
		calc_selected(first_time)
	
func calc_selected(first_time = false):
	var sel = get_node("CanvasLayer/Control/selected0")
	var lbl = get_node("CanvasLayer/Control/gun_slot0/lbl_stock")
	if !Global.gunz_equiped[Global.gunz_index].pasive and Global.gunz_equiped[Global.gunz_index].name != "none":
		lbl.text = "x" + str(Global.gunz_equiped[Global.gunz_index].stock)
	else:
		lbl.text = ""
	
	if !first_time:
		var count = 3
		for ei in range(count):
			var p = particle.instantiate()
			sel.add_child(p)
			
func _process(delta):
	pass
	#print("FPS " + str(Engine.get_frames_per_second()))

func _physics_process(delta):
	$CanvasLayer/Control/lbl_gameover.visible = Global.GAMEOVER
	
	if Global.GAMEOVER:
		gameover_ttl -= 1 * delta
		if gameover_ttl <= 0:
			gameover_ttl = gameover_ttl_total
			if Global.GAMEOVER:
				if !Global.BOSS_ROOM:
					Global.reset_gunz()
				Global.restore_gunz()
				Global.scene_next()
				Global.GAMEOVER = false
			return
		
	if Global.exit_door and is_instance_valid(Global.exit_door) and Global.exit_door.closed:
		var targets = get_tree().get_nodes_in_group("prisoners")
		if targets.size() > 0:
			var found = false
			for t in targets:
				if t.trapped:
					found = true
					break
			if !found:
				var water_gen = get_tree().get_nodes_in_group("water_generation")
				for w in water_gen:
					w.start()
				Global.exit_door.open()
		
	var sel = get_node("/root/Main/CanvasLayer/Control/PrisonerHead/counter")
	
	if Global.TerminalNumber == Global.TerminalsEnum.TOMB:
		$CanvasLayer/Control/PrisonerHead.animation = "tomb"
	elif Global.TerminalNumber == Global.TerminalsEnum.MERMAID:
		$CanvasLayer/Control/PrisonerHead.animation = "faucet"
	
	if sel:
		sel.text = str(Global.prisoner_total - Global.prisoner_counter) + "/" + str(Global.prisoner_total) 
		
	if Global.TerminalNumber == Global.TerminalsEnum.SALAMANDER:
		$CanvasLayer/Control/PrisonerHead.visible = false
		
	if Global.BOSS_ROOM or Global.CurrentState == Global.GameStates.OVERWORLD or Global.CurrentState == Global.GameStates.SHOP:
		$CanvasLayer/Control/PrisonerHead.visible = false
		
	#if Input.is_action_just_pressed("fx"):
		#$FX.visible = !$FX.visible
		##
	
	if Input.is_action_just_pressed("toggle_fullscreen"):
		Global.FULLSCREEN = !Global.FULLSCREEN
		if Global.FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			return
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			return
