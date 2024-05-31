extends Node2D
var particle = preload("res://scenes/particle2.tscn")
var player_placed = false
var rooms_top = [
	load("res://scenes/levels/room_top1.tscn"),
	load("res://scenes/levels/room_top2.tscn")  
]
var rooms_middle = [
	load("res://scenes/levels/room_middle1.tscn")
]
var rooms_bottom = [
	load("res://scenes/levels/room_bottom0.tscn"),
	load("res://scenes/levels/room_bottom1.tscn")
]

func generate_level():
	var player_room = Vector2(randi() % 4, 0)
	var door_room = Vector2(randi() % 4, randi() % 4)
	var size = Vector2(1152, 640) #TODO: Cambiar
	var room_pos = Vector2.ZERO
	var room = null
	var q = 1
	
	for h in range(4):
		for w in range(4):
			if h == 0:
				room = Global.pick_random(rooms_top)

			if h == 1 or h == 2:
				room = Global.pick_random(rooms_middle)
			
			if h == 3:
				room = Global.pick_random(rooms_bottom)
				
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

func _ready():
	generate_level()
	Global.GizmoWatcher = self
	setHUD()

func setHUD():
	for i in range(Global.gunz_equiped.size()):
		var slot = get_node("CanvasLayer/Control/gun_slot" + str(i))
		slot.animation = Global.gunz_equiped[i].name
	calc_selected()
	
func calc_selected():
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
			var count = 3
			for ei in range(count):
				var p = particle.instantiate()
				sel.add_child(p)
				p.global_position = sel.global_position

func _physics_process(delta):
	$CanvasLayer/Control/lbl_gameover.visible = Global.GAMEOVER
		
	if Global.exit_door and Global.exit_door.closed:
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
		sel.text = "x" + str(Global.prisoner_counter)
		
	if Input.is_action_just_pressed("fx"):
		$FX.visible = !$FX.visible
		
	if Input.is_action_just_pressed("restart"):
		Global.init()
		get_tree().reload_current_scene()
	
	if Input.is_action_pressed("toggle_fullscreen"):
		Global.FULLSCREEN = !Global.FULLSCREEN
		if Global.FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			return
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			return
