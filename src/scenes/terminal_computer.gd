extends Area2D
var active = false
var opened = false
var player = null
var delay_camera = 0.2
var current_line = 2
var current_message = "" 
var ttl = 0
var CMD : TextEdit
var command = ""
var is_writing = false 
@export var terminal_number = -1
@export var InfoPosition : Marker2D
var terminal_commands = [
	[
		"GAME",
		"HELP",
		"LIST",
		"PRINT",
		"CLEAR",
		"EXIT",
	],
	[
		"HELP",
		"SET",
		"VARIABLES",
		"PRINT",
		"CLEAR",
		"EXIT",
	],
	[
		"HELP",
		"SET",
		"VARIABLES",
		"PRINT",
		"CLEAR",
		"EXIT",
	],
	[
		"HELP",
		"SET",
		"VARIABLES",
		"PRINT",
		"CLEAR",
		"EXIT",
	],
	[
		"HELP",
		"SET",
		"VARIABLES",
		"PRINT",
		"CLEAR",
		"EXIT",
	],
]

func _ready():
	if terminal_number == -1:
		terminal_number = Global.LevelCurrentTerminalNumber
		 
	add_to_group("terminals")
	CMD = $Terminal/TextEdit
	$Info.global_position = InfoPosition.global_position

func _physics_process(delta):
	$back2.visible = $back.visible 
	if !active and opened:
		if player:
			if delay_camera > 0:
				delay_camera -= 1 * delta
				if delay_camera <= 0:
					player.dont_camera = false
	
	if active and !opened:
		if Input.is_action_just_pressed("up"):
			if Global.player_obj.is_on_floor_custom():
				opened = true
				active = false
				Global.emit(global_position, 5)
				$back.visible = false
				$back/arrows.visible = false
				$Terminal.visible = true
				current_message = "WELCOME TO GROTTO TERMINAL #" + str(terminal_number) + " " + Global.Terminals[terminal_number].name + "\nREADY"
				Global.player_obj.terminal_mode = true
				Global.player_obj.visible = false
			
func _process(delta):
	if current_message:
		is_writing = true
		ttl -= 1 * delta
		if ttl <= 0:
			ttl = 0.05
			CMD.set_focus_mode(2)
			CMD.grab_focus()
			CMD.insert_text_at_caret(current_message.substr(0, 1))
			current_message = current_message.substr(1, current_message.length() - 1)
			if current_message == "":
				CMD.set_caret_line(current_line)
				is_writing = false
				
func _input(event):
	if !is_writing and opened and current_message == "": 
		if event is InputEventKey and event.is_pressed():
			var key_text  = OS.get_keycode_string(event.keycode)
			if event.keycode == Key.KEY_KP_ENTER or event.keycode == Key.KEY_ENTER:
				current_line += 1
				parser(command)
				command = ""
			else:
				if event.keycode == Key.KEY_BACKSPACE:
					command = command.left(command.length() - 1)
				elif (event.keycode >= 65 and event.keycode <= 90) or event.keycode == 32:
					command += key_text
		
func parser(_cmd):
	var found = terminal_commands[terminal_number].find(_cmd)
	if found != -1 and _cmd == "HELP":
		var commands = "\n".join(terminal_commands[terminal_number])
		current_message = "AVAILABLE COMMANDS:\n" + commands
		current_line += terminal_commands[terminal_number].size() + 1
	elif found != -1 and _cmd == "CLEAR":
		CMD.text = ""
		current_line = 0 
	elif found != -1 and _cmd == "GAME":
		current_message = "STARTING..."
		current_line += 1
		await get_tree().create_timer(1.5).timeout
		get_tree().change_scene_to_file("res://scenes/levels/room_retro_game.tscn")
	elif found != -1 and _cmd == "PRINT":
		current_message = "PRINTING...\nREADY"
		current_line += 2
		$Info.visible = true
		$Info.terminal_number = terminal_number
	elif found != -1 and _cmd == "LIST":
		var commands = ""
		var lines = 0
		for i in range(Global.Terminals.size()):
			commands += "#" + str(i) + " " + Global.Terminals[i].name + " | STATUS: " + trad_state(Global.Terminals[i].status) + "\n"
			lines += 1
			var vars = trad_vars(Global.Terminals[i].variable)
			if vars != "":
				commands += "\t" + vars+ "\n\n"
				lines += 2
		current_message = "LIST OF TERMINALS:\n" + commands + "\nREADY"
		current_line += lines + 3
	elif found != -1 and _cmd == "EXIT":
		CMD.text = ""
		current_line = 2
		$Terminal.visible = false
		$back.visible = false
		active = false
		opened = false
		Global.player_obj.terminal_mode = false
		Global.player_obj.visible = true
	else:
		current_message = "ERROR: TYPE HELP <COMMAND> OR HELP FOR A LIST OF COMMANDS"
		current_line += 1
		
func trad_vars(val):
	if val != {}:
		return str(val).replace("{", "").replace("}", "")
	else:
		return ""
		
func trad_state(val):
	if val == true:
		return "ON"
	elif val == false:
		return "OFF"
	elif val == null:
		return "UNKNOWN"
	
			
func _on_body_entered(body):
	if !opened and body.is_in_group("players") and !body.is_in_group("prisoners"):
		body.dont_camera = true
		$back.visible = true
		active = true
		player = body

func _on_body_exited(body):
	if body.is_in_group("players") and !body.is_in_group("prisoners"):
		body.dont_camera = false
		$back.visible = false
		active = false
		body.dont_camera = false
