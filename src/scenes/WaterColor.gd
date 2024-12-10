extends ColorRect

func _physics_process(delta):
	if Global.TerminalNumber != Global.TerminalsEnum.MERMAID or Global.TunnelTerminalNumber:
		queue_free()
