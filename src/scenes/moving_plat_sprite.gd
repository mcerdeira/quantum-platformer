extends Node2D

func _ready():
	if Global.TerminalNumber == Global.TerminalsEnum.TOMB:
		$sprite.animation = "tomb"
		$sprite2.animation = "tomb"
		$sprite3.animation = "tomb"
		
	if Global.TerminalNumber == Global.TerminalsEnum.MERMAID:
		$sprite.animation = "rain"
		$sprite2.animation = "rain"
		$sprite3.animation = "rain"
		$rain_effect.visible = true
	else:
		$rain_effect.queue_free()	
		
