extends Node2D
var enabled = false

func _ready():
	Global.map_obj = self
	enabled = Global.find_my_item("map")

func _physics_process(_delta):
	if Global.GAMEOVER:
		visible = false
	else:
		if enabled and Global.CurrentState != Global.GameStates.TITLE:
			if Input.is_action_just_pressed("map") and !Global.BOSS_ROOM:
				if Global.CurrentState == Global.GameStates.RANDOMLEVEL:
					Global.play_sound(Global.MapSFX)
					visible = !visible
				else:
					if !Global.player_obj.showing_message():
						Global.player_obj.show_message_custom("No puedo usar el mapa aqui.")

func notify_map(q):
	var qq = get_node("q" + str(q))
	qq.animation = str(q)
	var qqq = get_node("q" + str(q) + "/prisoner")
	$player_q.global_position = qqq.global_position

func notify_prisoner(q):
	var qq = get_node("q" + str(q) + "/prisoner")
	qq.visible = true
	
func notify_prisoner_done(q):
	var qq = get_node("q" + str(q) + "/prisoner")
	qq.animation = "done"
