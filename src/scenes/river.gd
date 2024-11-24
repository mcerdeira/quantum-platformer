extends Node2D

func _ready():
	if Global.TerminalNumber != Global.TerminalsEnum.MERMAID:
		visible = false
		queue_free() 
