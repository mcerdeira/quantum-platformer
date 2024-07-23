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
var command_ok = false
@export var terminal_number = -1
@export var InfoPosition : Marker2D
var BUY_ITEMS = ["BOMB", "SMOKE", "CLONE", "SPRING", "PLANT", "MUFFIN"]

var PB_YES = ">"
var PB_NO = "-" 
var PB_LEN = 40

var terminal_commands_with_help = [
	[
		"BUY <ITEM> <QUANTITY>",
		"DONATE <QUANTITY>",
		"GAME",
		"HELP",
		"LIST",
		"PRINT",
		"CLEAR",
		"EXIT",
	],
	[
		"BUY <ITEM> <QUANTITY>",
		"HELP",
		"SET <VARIABLE> <VALUE>",
		"VARIABLES",
		"PRINT",
		"CLEAR",
		"EXIT",
	],
	[
		"BUY <ITEM> <QUANTITY>",
		"HELP",
		"SET <VARIABLE> <VALUE>",
		"VARIABLES",
		"PRINT",
		"CLEAR",
		"EXIT",
	],
	[
		"BUY <ITEM> <QUANTITY>",
		"HELP",
		"SET <VARIABLE> <VALUE>",
		"VARIABLES",
		"PRINT",
		"CLEAR",
		"EXIT",
	],
	[
		"BUY <ITEM> <QUANTITY>",
		"HELP",
		"SET <VARIABLE> <VALUE>",
		"VARIABLES",
		"PRINT",
		"CLEAR",
		"EXIT",
	],
]

var terminal_commands = [
	[
		"BUY",
		"DONATE",
		"GAME",
		"HELP",
		"LIST",
		"PRINT",
		"CLEAR",
		"EXIT",
	],
	[
		"BUY",
		"HELP",
		"SET",
		"VARIABLES",
		"PRINT",
		"CLEAR",
		"EXIT",
	],
	[
		"BUY",
		"HELP",
		"SET",
		"VARIABLES",
		"PRINT",
		"CLEAR",
		"EXIT",
	],
	[
		"BUY",
		"HELP",
		"SET",
		"VARIABLES",
		"PRINT",
		"CLEAR",
		"EXIT",
	],
	[
		"BUY",
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
	CMD = $display/Terminal/TextEdit
	$Info.global_position = InfoPosition.global_position

func _physics_process(delta):
	if $collider.disabled:
		if Global.fade_finished:
			$collider.set_deferred("disabled", false)
	
	$display/back2.visible = $display/back.visible 
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
				$display/back.visible = false
				$display/back/arrows.visible = false
				$display/Terminal.visible = true
				current_message = "WELCOME TO GROTTO TERMINAL #" + str(terminal_number) + " " + Global.Terminals[terminal_number].name + "\nREADY"
				Global.player_obj.terminal_mode = true
				Global.player_obj.visible = false
			
func _process(delta):
	if current_message:
		is_writing = true
		ttl -= 1 * delta
		if ttl <= 0:
			ttl = 0.05
			CMD.set_focus_mode(CMD.FOCUS_ALL)
			CMD.grab_focus()
			CMD.insert_text_at_caret(current_message.substr(0, 1))
			current_message = current_message.substr(1, current_message.length() - 1)
			if current_message == "":
				CMD.set_caret_line(current_line)
				is_writing = false
				
func _input(event):
	command_ok = false
	if !is_writing and opened and current_message == "": 
		if event is InputEventKey and event.is_pressed():
			var key_text  = OS.get_keycode_string(event.keycode)
			if event.keycode == Key.KEY_KP_ENTER or event.keycode == Key.KEY_ENTER:
				command_ok = true
				current_line += 1
				parser(command)
				command = ""
			else:
				if event.keycode == Key.KEY_BACKSPACE:
					if !command: 
						command_ok = false
					else:
						command = command.left(command.length() - 1)
						command_ok = true
				elif (event.keycode >= 65 and event.keycode <= 90):
					command_ok = true
					command += key_text
				elif (event.keycode >= 48 and event.keycode <= 57):
					command_ok = true
					command += key_text
				elif event.keycode == 32:
					command_ok = true
					command += " "
					
func calc_progress():
	if Global.CurrentLevel == Global.GOLD_PER_LEVEL.size() - 1:
		return "[" + PB_YES.repeat(PB_LEN) + "]"
	else:
		var total = Global.GOLD_PER_LEVEL[Global.CurrentLevel + 1]
		var current = Global.GoldDonation
		var percent = current * 100 / total
		var count = percent * PB_LEN / 100
		var rest =  PB_NO.repeat(PB_LEN - count)
		return "[" + PB_YES.repeat(count) + rest + "]"
		
func parser(_cmd):
	_cmd = _cmd.strip_edges()
	var cmd_c = _cmd.split(" ")
	var param1 = null
	var param2 = null
	if cmd_c.size() > 0:
		_cmd = cmd_c[0]
		if  cmd_c.size() >= 2:
			param1 = cmd_c[1]
		if  cmd_c.size() >= 3:
			param2 = cmd_c[2]
	
	var found = terminal_commands[terminal_number].find(_cmd)
	if found != -1 and _cmd == "HELP":
		if !param1:
			var commands = "\n".join(terminal_commands_with_help[terminal_number])
			current_message = "AVAILABLE COMMANDS:\n" + commands
			current_line += terminal_commands_with_help[terminal_number].size() + 1
		else:
			var cmd_found = terminal_commands[terminal_number].find(param1)
			if cmd_found == -1:
				current_message = "INVALID COMMAND: TYPE HELP <COMMAND> OR HELP FOR A LIST OF COMMANDS"
				current_line += 1
			else:
				if param1 == "BUY":
					current_message = "BUYS AN ITEM USING G-COINS\n"
					current_message += "USAGE BUY <ITEM> or BUY <ITEM> <QUANTITY>\n"
					current_message += "AVAILABLE ITEMS:\n"
					current_line += 3
					for i in BUY_ITEMS:
						current_message += i + "\n"
						current_line += 1
				elif param1 == "DONATE":
					current_message = "MAKES A G-COIN DONATION FOR THE CAUSE\n"
					current_message += "USAGE DONATE <QUANTITY>\n"
					current_line += 2
				elif param1 == "GAME":
					current_message = "LAUNCHS A GAME TO PASS TIME\n"
					current_line += 1
				elif param1 == "HELP":
					current_message = "THIS COMMAND\n"
					current_line += 1
				elif param1 == "LIST":
					current_message = "LISTS AVAILABLE TERMINALS AND STATUS\n"
					current_line += 1
				elif param1 == "PRINT":
					current_message = "PRINTS CURRENT TERMINAL MANUAL\n"
					current_line += 1
				elif param1 == "CLEAR":
					current_message = "CLEARS CONSOLE SCREEN\n"
					current_line += 1
				elif param1 == "EXIT":
					current_message = "EXITS CONSOLE SCREEN\n"
					current_line += 1
				elif param1 == "SET":
					current_message = "SETS A VARIABLE VALUE (TRUE OR FALSE)\n"
					current_message += "USAGE SET <VARIABLE> <T OR F>\n"
					current_line += 2
		
	elif found != -1 and _cmd == "BUY":
		if !param1:
			current_message = "ERROR: USE BUY <ITEM> or BUY <ITEM> <QUANTITY>\n"
			current_message += "AVAILABLE ITEMS:\n"
			current_line += 2
			for i in BUY_ITEMS:
				current_message += i + "\n"
				current_line += 1
		elif param1:
			var itm_found =  BUY_ITEMS.find(param1)
			if itm_found == -1:
				current_message = "ERROR: INVALID ITEM\n"
				current_message += "AVAILABLE ITEMS:\n"
				current_line += 2
				for i in BUY_ITEMS:
					current_message += i + "\n"
					current_line += 1
			else:	
				if !param2:
					param2 = 1
				else:
					if !param2.is_valid_integer():
						param2 = 1
					else:
						param2 = int(param2)
					
				if Global.buy_item(param1, param2):
					current_message = "TRANSACTION DONE\nREADY"
					current_line +=1
				else:
					current_message = "ERROR: NOT ENOUGH G-COINS\nREADY"
					current_line += 2
		
	elif found != -1 and _cmd == "DONATE":
		if Global.CurrentLevel == Global.GOLD_PER_LEVEL.size() - 1:
			current_message = "ERROR: NO MORE DONATIONS ALLOWED\nREADY"
			current_line += 2
		else:
			if !param1:
				current_message = "ERROR: USE DONATE <QUANTITY>\n"
				current_line += 1
			else:
				if !param1.is_valid_int():
					param1 = 1
				else:
					param1 = int(param1)
				
				var result = Global.donate(param1)
				if result != null:
					current_message = "TRANSACTION DONE\n"
					current_message += calc_progress() + "\n"
					current_line += 2
					if result != Global.perks_equiped:
						current_message +=  "\nNEW ITEMS AVAILABLE:\n"
						current_line += 2
						for i in range(Global.perks_equiped.size()):
							if i > 0:
								if result[i] == null and Global.perks_equiped[i] != null:
									current_message += "\t. " + Global.perks_equiped[i].name.to_upper() + "\n"
									current_message += "\t\t" + Global.perks_equiped[i].description + "\n"
									current_line += 2
					
					current_message +=  "\nREADY\n"
					current_line += 1
				else:
					current_message = "ERROR: NOT ENOUGH G-COINS\nREADY"
					current_line += 2

	elif found != -1 and _cmd == "CLEAR":
		CMD.text = ""
		current_line = 0 
	elif found != -1 and _cmd == "GAME":
		current_message = "STARTING..."
		current_line += 1
		Global.CameFromConsole = true
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
		$display/Terminal.visible = false
		$display/back.visible = false
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
		var center = Global.shaker_obj.camera.get_screen_center_position()
		$display.global_position = center
		$display/back.visible = true
		active = true
		player = body

func _on_body_exited(body):
	if body.is_in_group("players") and !body.is_in_group("prisoners"):
		body.dont_camera = false
		$display/back.visible = false
		active = false
		body.dont_camera = false
