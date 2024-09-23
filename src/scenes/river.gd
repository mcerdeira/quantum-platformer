extends Node2D


func _ready():
	if Global.CurrentState != Global.GameStates.OVERWORLD:
		visible = false
		queue_free() 
