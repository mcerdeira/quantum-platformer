extends Area2D
var active = false
var dead = false
var TOTAL_LIFE = 5.0
var LIFE = TOTAL_LIFE
var idx = 0
@export var pos : Array[Marker2D]
@export var Anim : AnimationPlayer

func _ready():
	Global.play_sound(Global.GhostBossLaughSFX)
	
func position():
	global_position = pos[idx].global_position
	idx += 1
	if idx > pos.size() - 1:
		idx = 0
	
func activate():
	Ambience.stop()
	Music.stop()
	Anim.play("new_animation")
	visible = true
	active = true
	Global.boss_bar.showme()

func _on_timer_timeout():
	activate()
