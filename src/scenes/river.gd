extends Node2D


func _ready():
	if Global.TerminalNumber != 3:
		queue_free()
