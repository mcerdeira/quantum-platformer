extends Sprite2D

func _physics_process(delta):
	if Global.BOSS_ROOM or Global.CurrentState == Global.GameStates.TITLE:
		queue_free()
		return
	if Global.TerminalNumber != Global.TerminalsEnum.LEAF or Global.TunnelTerminalNumber:
		queue_free()
		return
	visible = true
