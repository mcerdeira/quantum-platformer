extends Node2D

func _ready():
	add_to_group("color_button")
	show_button_color()

func _on_red_body_entered(body):
	if body.is_in_group("players") or body.is_in_group("interactuable"):
		switch_button()
		show_button_color()
		
func _on_blue_body_entered(body):
	if body.is_in_group("players") or body.is_in_group("interactuable"):
		switch_button()
		show_button_color()

func switch_button():
	var op_color = ""
	if Global.SwitchColorActive == "blue":
		Global.SwitchColorActive = "red"
		op_color = "blue"
	else:
		Global.SwitchColorActive = "blue"
		op_color = "red"
		
	var switches = get_tree().get_nodes_in_group("redblue_switch")
	for sw in switches:
		sw.close(Global.SwitchColorActive)
		sw.open(op_color)

func show_button_color():
	if Global.SwitchColorActive == "blue":
		$blue/sprite.frame = 1
		$red/sprite.frame = 0
	else:
		$blue/sprite.frame = 0
		$red/sprite.frame = 1
