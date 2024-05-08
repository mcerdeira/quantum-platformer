extends Node2D
var particle = preload("res://scenes/particle2.tscn")

func _ready():
	for i in range(Global.gunz_equiped.size()):
		var slot = get_node("CanvasLayer/Control/gun_slot" + str(i))
		slot.animation = Global.gunz_equiped[i]
	calc_selected()
	
func calc_selected():
	for i in range(Global.gunz_equiped.size()):
		var sel = get_node("CanvasLayer/Control/selected" + str(i))
		sel.visible = false
		if i == Global.gunz_index:
			sel.visible = true
			var count = 3
			for ei in range(count):
				var p = particle.instantiate()
				sel.add_child(p)
				p.global_position = sel.global_position

func _physics_process(delta):
	for player in Global.targets:
		if !player.dead:
			Global.GAMEOVER = false
			break
		
		Global.GAMEOVER = true
		
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
