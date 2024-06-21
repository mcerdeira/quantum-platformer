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
@export var terminal_number = 0
@export var InfoPosition : Marker2D
var terminal_commands = [
	[
		"TERMINALS",
		"HELP",
		"PRINT",
		"CLEAR",
		"EXIT",
	]
]

func _ready():
	CMD = $Terminal/TextEdit

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
			opened = true
			active = false
			Global.emit(global_position, 5)
			$back.visible = false
			$back/arrows.visible = false
			$Terminal.visible = true
			current_message = "WELCOME TO GROTTO TERMINAL #" + str(terminal_number) + " " + Global.TerminalNames[terminal_number] + "\nREADY"
			Global.player_obj.terminal_mode = true
			Global.player_obj.visible = false
			
func _process(delta):
	if current_message:
		is_writing = true
		ttl -= 1 * delta
		if ttl <= 0:
			ttl = 0.1
			CMD.set_focus_mode(2)
			CMD.grab_focus()
			CMD.insert_text_at_caret(current_message.substr(0, 1))
			current_message = current_message.substr(1, current_message.length() - 1)
			if current_message == "":
				CMD.set_caret_line(current_line)
				is_writing = false
				
func _input(event):
	if opened and current_message == "": 
		if event is InputEventKey and event.is_pressed():
			var key_text  = OS.get_keycode_string(event.keycode)
			if key_text == "Enter":
				current_line += 1
				parser(command)
				command = ""
			else:
				if (event.keycode >= 65 and event.keycode <= 90) or event.keycode == 32:
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
	elif found != -1 and _cmd == "PRINT":
		#$Info.visible = true
		pass
	elif found != -1 and _cmd == "TERMINALS":
		var commands = ""
		for i in range(Global.TerminalNames.size()):
			commands += "#" + str(i) + " " + Global.TerminalNames[i] + " - STATUS: " + Global.TerminalStatus[i] + "\n"
		current_message = "LIST OF TERMINALS:\n" + commands
		current_line += Global.TerminalNames.size() + 1
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
