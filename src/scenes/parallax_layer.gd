extends Node2D

@export var foreground_tree := Node2D   # tu sprite en foreground
@export var fg_factor := 1.5   # foreground, se mueve más que la cámara
@export var type = ""
var fg_start_pos := 0

func _ready():
	# guardo las posiciones iniciales
	fg_start_pos = foreground_tree.position.x

func _process(_delta):
	if Global.BOSS_ROOM or Global.CurrentState == Global.GameStates.TITLE:
		queue_free()
		return
	if type == "trees":
		if Global.TerminalNumber != Global.TerminalsEnum.MERMAID or Global.TunnelTerminalNumber:
			queue_free()
			return
	elif type == "tomb":
		if Global.TerminalNumber != Global.TerminalsEnum.TOMB or Global.TunnelTerminalNumber:
			queue_free()
			return
	visible = true
	if Global.shaker_obj and Global.shaker_obj.camera:
		var cam_pos = Global.shaker_obj.camera.global_position.x
		foreground_tree.position.x = fg_start_pos + cam_pos * (fg_factor - 1.0)
