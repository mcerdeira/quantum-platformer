extends Area2D
var active = false
var opened = false
var player = null
var delay_camera = 0.2
var current_message = "" 
var ttl = 0
var ttl_total_normal = 0.05
var ttl_total = ttl_total_normal
var CMD : TextEdit
var cursor = "▶"
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
		"STATUS",
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

var commands_idx = -1
var param1_idx = -1
var param2_idx = -1
var numeric_param = 0
var mode_idx = 0
var mode = ["cmd", "param1", "param2"]


var BUY = {
	"name": "BUY",
	"param1": BUY_ITEMS,
	"param2": 1
}
var DONATE = {
	"name": "DONATE",
	"param1": 1,
	"param2": null
}
var STATUS = {
	"name": "STATUS",
	"param1": null,
	"param2": null
}
var GAME = {
	"name": "GAME",
	"param1": null,
	"param2": null
} 
var HELP = {
	"name": "HELP",
	"param1": ["BUY", "DONATE", "STATUS", "GAME", "LIST", "PRINT", "CLEAR", "EXIT"],
	"param2": null
}

var HELP2 = {
	"name": "HELP",
	"param1": ["BUY", "SET", "VARIABLES", "PRINT", "CLEAR", "EXIT"],
	"param2": null
}

var SET = {
	"name": "SET",
	"param1": [trad_vars(Global.Terminals[terminal_number].variable)],
	"param2": ["ON", "OFF"]
}
var VARIABLES = {
	"name": "VARIABLES",
	"param1": null,
	"param2": null
}

var LIST = {
	"name": "LIST",
	"param1": null,
	"param2": null
}
var PRINT = {
	"name": "PRINT",
	"param1": null,
	"param2": null
}
var CLEAR = {
	"name": "CLEAR",
	"param1": null,
	"param2": null
}
var EXIT = {
	"name": "EXIT",
	"param1": null,
	"param2": null
}

var terminal_commands = [
	[
		BUY,
		DONATE,
		STATUS,
		GAME,
		HELP,
		LIST,
		PRINT,
		CLEAR,
		EXIT,
	],
	[
		BUY,
		HELP2,
		SET,
		VARIABLES,
		PRINT,
		CLEAR,
		EXIT,
	],
	[
		BUY,
		HELP2,
		SET,
		VARIABLES,
		PRINT,
		CLEAR,
		EXIT,
	],
	[
		BUY,
		HELP2,
		SET,
		VARIABLES,
		PRINT,
		CLEAR,
		EXIT,
	],
	[
		BUY,
		HELP2,
		SET,
		VARIABLES,
		PRINT,
		CLEAR,
		EXIT,
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
				Global.play_sound(Global.TerminalONSFX)
				Global.play_sound(Global.InteractSFX)
				opened = true
				active = false
				Global.emit(global_position, 5)
				$display/back.visible = false
				$display/back/arrows.visible = false
				$display/Terminal.visible = true
				current_message = "WELCOME TO GROTTO TERMINAL #" + str(terminal_number) + " " + Global.Terminals[terminal_number].name.strip_edges() + "# \nREADY\n"
				Global.player_obj.terminal_mode = true
				Global.player_obj.visible = false
			
func _process(delta):
	if current_message:
		is_writing = true
		ttl -= 1 * delta
		if ttl <= 0:
			ttl = ttl_total
			CMD.set_focus_mode(CMD.FOCUS_ALL)
			CMD.grab_focus()
			CMD.insert_text_at_caret(current_message.substr(0, 1))
			current_message = current_message.substr(1, current_message.length() - 1)
			if current_message == "":
				ttl_total = ttl_total_normal
				is_writing = false
				
func _input(event):
	command_ok = false
	if !is_writing and opened and current_message == "": 
		if event is InputEventKey and event.is_pressed():
			var key_text  = OS.get_keycode_string(event.keycode)
			if event.keycode == Key.KEY_RIGHT:
				Global.play_sound(Global.TerminalClickSFX)
				if KeyRight():
					KeyUpDown(Key.KEY_UP)
	
			if event.keycode == Key.KEY_UP or event.keycode == Key.KEY_DOWN:
				Global.play_sound(Global.TerminalClickSFX)
				KeyUpDown(event.keycode)
			
			elif event.keycode == Key.KEY_KP_ENTER or event.keycode == Key.KEY_ENTER:
				Global.play_sound(Global.TerminalClickSFX)
				commands_idx = -1
				param1_idx = -1
				param2_idx = -1
				numeric_param = 0
				mode_idx = 0
				command_ok = true
				command = command.replace(cursor, " ")
				
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
					
func KeyUpDown(event_keycode):
	var dir = 1
	if event_keycode == Key.KEY_DOWN:
		dir = -1
	
	ttl_total = 0.01
	command_ok = true
	
	if mode[mode_idx] == "cmd":
		commands_idx += dir
		if commands_idx > terminal_commands[terminal_number].size() -1:
			commands_idx = 0
		if commands_idx < 0:
			commands_idx = terminal_commands[terminal_number].size() -1
		
		command = cursor + terminal_commands[terminal_number][commands_idx].name
		 
		current_message = command
		CMD.text = ""
			
	if mode[mode_idx] == "param1":
		if terminal_commands[terminal_number][commands_idx].param1 != null:
			if typeof(terminal_commands[terminal_number][commands_idx].param1) == TYPE_ARRAY:
				param1_idx += dir
				if param1_idx > terminal_commands[terminal_number][commands_idx].param1.size() -1:
					param1_idx = 0
				if param1_idx < 0:
					param1_idx = terminal_commands[terminal_number][commands_idx].param1.size() -1
				
				command = terminal_commands[terminal_number][commands_idx].name
				command += cursor +  terminal_commands[terminal_number][commands_idx].param1[param1_idx]
				
				current_message = command
				CMD.text = ""
			else:
				numeric_param += dir
				if numeric_param > Global.Gold:
					numeric_param = Global.Gold
				if numeric_param < 0:
					numeric_param = 0	
				
				command = terminal_commands[terminal_number][commands_idx].name
				command += cursor + str(numeric_param)
				
				current_message = command
				CMD.text = ""
		
	if mode[mode_idx] == "param2":
		if terminal_commands[terminal_number][commands_idx].param2 != null:
			numeric_param += dir
			if numeric_param > Global.Gold:
				numeric_param = Global.Gold
			if numeric_param < 0:
				numeric_param = 0
				
			command = terminal_commands[terminal_number][commands_idx].name
			command += " " + terminal_commands[terminal_number][commands_idx].param1[param1_idx]
			command += cursor + str(numeric_param)
			
			current_message = command
			CMD.text = ""
	
func KeyRight():
	if mode_idx == 0 and terminal_commands[terminal_number][commands_idx].param1 == null:
		return false
	if mode_idx == 1 and terminal_commands[terminal_number][commands_idx].param2 == null:
		return false
		
	#Actual Logic inits
	ttl_total = 0.01
	command_ok = true
	CMD.text = ""
	if mode_idx == 0:
		current_message = command.replace(cursor, "") + cursor
	else:
		current_message = command.replace(cursor, " ") + cursor
	mode_idx += 1
	if mode_idx > mode.size() - 1:
		mode_idx = 0
		
	return true
					
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
		
func calc_progress_percent():
	if Global.CurrentLevel == Global.GOLD_PER_LEVEL.size() - 1:
		return "(100%)"
	else:
		var total = Global.GOLD_PER_LEVEL[Global.CurrentLevel + 1]
		var current = Global.GoldDonation
		var percent = current * 100 / total
		return "(" + str(round(percent)) + "%)"
		
func find_cmd(_cmd):
	for c in terminal_commands[terminal_number]:
		if c.name == _cmd:
			return 1
	
	return -1
	
	
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
	
	var found = find_cmd(_cmd)
	if found != -1 and _cmd == "HELP":
		if !param1:
			var commands = "\n".join(terminal_commands_with_help[terminal_number])
			current_message = "AVAILABLE COMMANDS:\n" + commands + "\n"
		else:
			var cmd_found = find_cmd(param1)
			if cmd_found == -1:
				current_message = "INVALID COMMAND: TYPE HELP <COMMAND> OR HELP FOR A LIST OF COMMANDS" + "\n"
			else:
				if param1 == "BUY":
					current_message = "BUYS AN ITEM USING G-COINS\n"
					current_message += "USAGE BUY <ITEM> or BUY <ITEM> <QUANTITY>\n"
					current_message += "AVAILABLE ITEMS:\n"
					for i in BUY_ITEMS:
						current_message += i + "\n"
				elif param1 == "DONATE":
					current_message = "MAKES A G-COIN DONATION FOR THE CAUSE\n"
					current_message += "USAGE DONATE <QUANTITY>\n"
				elif param1 == "STATUS":
					current_message = "SHOWS CURRENT DONATIONS STATUS\n"
				elif param1 == "GAME":
					current_message = "LAUNCHS A GAME TO PASS TIME\n"
				elif param1 == "HELP":
					current_message = "THIS COMMAND\n"
				elif param1 == "LIST":
					current_message = "LISTS AVAILABLE TERMINALS AND STATUS\n"
				elif param1 == "PRINT":
					current_message = "PRINTS CURRENT TERMINAL MANUAL\n"
				elif param1 == "CLEAR":
					current_message = "CLEARS CONSOLE SCREEN\n"
				elif param1 == "EXIT":
					current_message = "EXITS CONSOLE SCREEN\n"
				elif param1 == "SET":
					current_message = "SETS A VARIABLE VALUE (TRUE OR FALSE)\n"
					current_message += "USAGE SET <VARIABLE> <T OR F>\n"
		
	elif found != -1 and _cmd == "BUY":
		if !param1:
			current_message = "ERROR: USE BUY <ITEM> or BUY <ITEM> <QUANTITY>\n"
			current_message += "AVAILABLE ITEMS:\n"
			for i in BUY_ITEMS:
				current_message += i + "\n"
		elif param1:
			var itm_found =  BUY_ITEMS.find(param1)
			if itm_found == -1:
				current_message = "ERROR: INVALID ITEM\n"
				current_message += "AVAILABLE ITEMS:\n"
				for i in BUY_ITEMS:
					current_message += i + "\n"
			else:	
				if !param2:
					param2 = 1
				else:
					if !param2.is_valid_int():
						param2 = 1
					else:
						param2 = int(param2)
					
				if Global.buy_item(param1, param2):
					current_message = "TRANSACTION DONE\nREADY" + "\n"
				else:
					current_message = "ERROR: NOT ENOUGH G-COINS\nREADY" + "\n"
		
	elif found != -1 and _cmd == "DONATE":
		if Global.CurrentLevel == Global.GOLD_PER_LEVEL.size() - 1:
			current_message = "ERROR: NO MORE DONATIONS ALLOWED\nREADY" + "\n"
		else:
			if !param1:
				current_message = "ERROR: USE DONATE <QUANTITY>\n"
			else:
				if !param1.is_valid_int():
					param1 = 1
				else:
					param1 = int(param1)
				
				var result = Global.donate(param1)
				if result != null:
					current_message = "TRANSACTION DONE\n"
					current_message += calc_progress() + "\n"
					current_message += calc_progress_percent() + "\n"
					if result != Global.perks_equiped:
						current_message +=  "\nNEW ITEMS AVAILABLE:\n"
						for i in range(Global.perks_equiped.size()):
							if i > 0:
								if result[i] == null and Global.perks_equiped[i] != null:
									current_message += "\t. " + Global.perks_equiped[i].name.to_upper() + "\n"
									current_message += "\t\t" + Global.perks_equiped[i].description + "\n"
					
					current_message +=  "\nREADY\n"
				else:
					current_message = "ERROR: NOT ENOUGH G-COINS\nREADY" + "\n"

	elif found != -1 and _cmd == "CLEAR":
		CMD.text = ""
	elif found != -1 and _cmd == "STATUS":
		current_message = "DONATIONS STATUS: "+ "\n"
		current_message += calc_progress() + "\n"
		current_message += calc_progress_percent() + "\n"
		current_message +=  "READY\n"
	elif found != -1 and _cmd == "GAME":
		current_message = "STARTING..."
		Global.CameFromConsole = true
		await get_tree().create_timer(1.5).timeout
		get_tree().change_scene_to_file("res://scenes/levels/room_retro_game.tscn")
	elif found != -1 and _cmd == "PRINT":
		Global.play_sound(Global.TerminalPrintSFX)
		current_message = "PRINTING...\nREADY" + "\n"
		$Info.visible = true
		$Info.terminal_number = terminal_number
	elif found != -1 and _cmd == "LIST":
		var commands = ""
		var lines = 0
		for i in range(Global.Terminals.size()):
			commands += "#" + str(i) + " " + Global.Terminals[i].name + "# | STATUS: " + trad_state(Global.Terminals[i].status) + "\n"
			lines += 1
			var vars = trad_vars(Global.Terminals[i].variable)
			if vars != "":
				commands += "\t" + vars+ "\n\n"
				lines += 2
		current_message = "LIST OF TERMINALS:\n" + commands + "\nREADY" + "\n"
	elif found != -1 and _cmd == "EXIT":
		CMD.text = ""
		$display/Terminal.visible = false
		$display/back.visible = false
		active = false
		opened = false
		Global.player_obj.terminal_mode = false
		Global.player_obj.visible = true
	else:
		current_message = "ERROR: TYPE HELP <COMMAND> OR HELP FOR A LIST OF COMMANDS" + "\n"
		
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
