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

var rooms_bottom_dragon = [
	preload("res://scenes/levels/room_bottom_dragon.tscn")
]
var rooms_middle_dragon = [
	preload("res://scenes/levels/room_middle_dragon.tscn")
]
var rooms_top_dragon = [
	preload("res://scenes/levels/room_top_dragon.tscn")
]

var rooms_top = [
	preload("res://scenes/levels/room_top1.tscn"),
	preload("res://scenes/levels/room_top2.tscn")
]
var rooms_middle1 = [
	preload("res://scenes/levels/room_middle1.tscn")
]
var rooms_middle2 = [
	preload("res://scenes/levels/room_middle2.tscn")
]

var rooms_bottom = [
	load("res://scenes/levels/room_bottom0.tscn"),
	load("res://scenes/levels/room_bottom1.tscn")
]

var list_rooms_top = [
	null,
	rooms_top,
	null,
	null,
	rooms_top_dragon
]
var list_rooms_middle1 = [
	null,
	rooms_middle1,
	null,
	null,
	rooms_middle_dragon
]
var list_rooms_middle2  = [
	null,
	rooms_middle2,
	null,
	null,
	rooms_middle_dragon
]
var list_rooms_bottom  = [
	null,
	rooms_bottom,
	null,
	null,
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
		
func generate_level():
	var player_room = Vector2(randi() % 4, 0)
	var door_room = Vector2(randi() % 4, randi() % 4)
	var size = Vector2(1152, 640) #TODO: Cambiar
	var room_pos = Vector2.ZERO
	var room = null
	var q = 1
	var prisonercount = Global.Terminals[Global.TerminalNumber].prisoners
	var _rooms_top = list_rooms_top[Global.TerminalNumber]
	var _rooms_middle1 = list_rooms_middle1[Global.TerminalNumber]
	var _rooms_middle2 = list_rooms_middle2[Global.TerminalNumber]
	var _rooms_bottom = list_rooms_bottom [Global.TerminalNumber]
	
	for h in range(4):
		for w in range(4):
			if h == 0:
				room = Global.pick_random(_rooms_top)

			if h == 1:
				room = Global.pick_random(_rooms_middle1)
				
			if h == 2:
				room = Global.pick_random(_rooms_middle2)
			
			if h == 3:
				room = Global.pick_random(_rooms_bottom)
				
			var r = room.instantiate()
			r.global_position = room_pos
			r.q = q
			q += 1
			
			room_pos.x += size.x
			if player_room != Vector2(w, h):
				r.delete_player()
				
			if door_room != Vector2(w, h):
				r.delete_door()
			
			add_child(r)
		
		room_pos.y += size.y
		room_pos.x = 0
		
	var terminals = get_tree().get_nodes_in_group("terminals")
	while terminals.size() > 1:
		terminals.shuffle()
		var t = terminals.pop_front()
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
		pm.queue_free()
	
	prisoner_markers = get_tree().get_nodes_in_group("prisoner_markers")
	for _pm in prisoner_markers:
		_pm.done = true
		
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	if Global.CurrentState == Global.GameStates.RANDOMLEVEL:
		generate_level()
	if Global.CurrentState == Global.GameStates.TITLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		generate_fixed_level(room_title, false)
	if Global.CurrentState == Global.GameStates.HOME:
		generate_fixed_level(room_home, false)
	if Global.CurrentState == Global.GameStates.OUTSIDE:
		generate_fixed_level(room_outside, false)
	if Global.CurrentState == Global.GameStates.FALLING:
		generate_fixed_level(room_falling, false)
	if Global.CurrentState == Global.GameStates.OVERWORLD:
		generate_fixed_level(room_overworld, true)
		
	Global.GizmoWatcher = self
	setHUD(false, true)

func setHUD(only_gold = false, first_time = false):
	var lbl_coin = get_node("CanvasLayer/Control/coin_slot2/lbl_stock")
	lbl_coin.text = "x" + str(Global.Gold)
	
	for i in range(1, Global.CurrentLevel + 1):
		var perk = get_node("CanvasLayer/Control/perks" + str(i))
		perk.visible = true
	
	if only_gold:
		return
		
	for i in range(Global.gunz_equiped.size()):
		var slot = get_node("CanvasLayer/Control/gun_slot" + str(i))
		slot.animation = Global.gunz_equiped[i].name
	calc_selected(first_time)
	
func calc_selected(first_time = false):
	for i in range(Global.gunz_equiped.size()):
		var sel = get_node("CanvasLayer/Control/selected" + str(i))
		sel.visible = false
		var lbl = get_node("CanvasLayer/Control/gun_slot" + str(i) + "/lbl_stock")
		if !Global.gunz_equiped[i].pasive and Global.gunz_equiped[i].name != "none":
			lbl.text = "x" + str(Global.slots_stock[i])
		else:
			lbl.text = ""
		
		if i == Global.gunz_index:
			sel.visible = true
			if !first_time:
				var count = 3
				for ei in range(count):
					var p = particle.instantiate()
					sel.add_child(p)

func _physics_process(delta):
	$CanvasLayer/Control/lbl_gameover.visible = Global.GAMEOVER
	
	if Global.GAMEOVER:
		gameover_ttl -= 1 * delta
		if gameover_ttl <= 0:
			gameover_ttl = gameover_ttl_total
			Global.GAMEOVER = false
			Global.reset_gunz()
			Global.scene_next()
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
				Global.exit_door.open()
		
	var sel = get_node("/root/Main/CanvasLayer/Control/PrisonerHead/counter")
	if sel:
		sel.text = str(Global.prisoner_total - Global.prisoner_counter) + "/" + str(Global.prisoner_total) 
		
	#if Input.is_action_just_pressed("fx"):
		#$FX.visible = !$FX.visible
		##
	
	if Input.is_action_pressed("toggle_fullscreen"):
		Global.FULLSCREEN = !Global.FULLSCREEN
		if Global.FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			return
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			return
