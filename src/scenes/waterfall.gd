extends Node2D

func _ready():
	if Global.TerminalNumber == Global.TerminalsEnum.MERMAID:
		var val = Global.pick_random([0.1, 0.1, 0.1, 1])
		modulate.a = val 
		if val == 1:
			z_index = 4095
		
	else:
		queue_free()
