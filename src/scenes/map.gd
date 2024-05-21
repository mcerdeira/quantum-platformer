extends Node2D

func _ready():
	Global.map_obj = self

func notify_map(q):
	var qq = get_node("q" + str(q))
	qq.animation = "on"

func notify_prisoner(q):
	var qq = get_node("q" + str(q) + "/prisoner")
	qq.visible = true
	
func notify_prisoner_done(q):
	var qq = get_node("q" + str(q) + "/prisoner")
	qq.animation = "done"
