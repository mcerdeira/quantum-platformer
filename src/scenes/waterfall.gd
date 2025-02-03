extends Node2D

func _ready():
	var val = Global.pick_random([0.1, 0.1])
	modulate.a = val 
	if val == 1:
		z_index = 4095

func _physics_process(delta):
	if Global.BOSS_ROOM:
		queue_free()
	if Global.TerminalNumber != Global.TerminalsEnum.MERMAID or Global.TunnelTerminalNumber:
		queue_free()
