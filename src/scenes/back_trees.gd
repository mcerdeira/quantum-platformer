extends Sprite2D

func _ready() -> void:
	if Global.BOSS_ROOM:
		queue_free()
		return
	if Global.TerminalNumber != Global.TerminalsEnum.MERMAID or Global.TunnelTerminalNumber:
		queue_free()
		return
	visible = true
