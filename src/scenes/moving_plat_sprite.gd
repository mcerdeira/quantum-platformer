extends Node2D

func _ready():
	if Global.TerminalNumber == Global.TerminalsEnum.TOMB:
		$sprite.animation = "tomb"
		$sprite2.animation = "tomb"
		$sprite3.animation = "tomb"
