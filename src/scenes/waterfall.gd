extends Node2D

func _ready():
	if Global.TerminalNumber == Global.TerminalsEnum.MERMAID:
		modulate.a = Global.pick_random([0.43, 0.1, 0.7])
	else:
		queue_free()
