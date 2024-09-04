extends Node2D


func _ready():
	if Global.TerminalNumber != Global.TerminalsEnum.MERMAID:
		queue_free()
