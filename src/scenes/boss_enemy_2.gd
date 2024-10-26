extends Area2D
var active = false
var dead = false
var TOTAL_LIFE = 5.0
var LIFE = TOTAL_LIFE

func _ready():
	Global.play_sound(Global.GhostBossLaughSFX)

func activate():
	Ambience.stop()
	Music.play(Global.BossThemeGhost)
	visible = true
	active = true
	Global.boss_bar.showme()

func _on_timer_timeout():
	activate()
