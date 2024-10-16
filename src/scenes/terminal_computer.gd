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
var BUY_ITEMS = ["BOMBA", "HUMO", "CLONADOR", "RESORTE", "PLANTITA", "GOLOSINA", "TELETRANSPORTADOR"]

var PB_YES = ">"
var PB_NO = "-" 
var PB_LEN = 40

var terminal_commands_with_help = [
	[
		"ESTADO",
		"JUEGO",
		"AYUDA",
		"LISTAR",
		"IMPRIMIR",
		"LIMPIAR",
		"SALIR",
	],
	[
		"AYUDA",
		"ESTABLECER <VARIABLE> <VALOR>",
		"VARIABLES",
		"IMPRIMIR",
		"LIMPIAR",
		"SALIR",
	],
	[
		"AYUDA",
		"ESTABLECER <VARIABLE> <VALOR>",
		"VARIABLES",
		"IMPRIMIR",
		"LIMPIAR",
		"SALIR",
	],
	[
		"AYUDA",
		"ESTABLECER <VARIABLE> <VALOR>",
		"VARIABLES",
		"IMPRIMIR",
		"LIMPIAR",
		"SALIR",
	],
	[
		"AYUDA",
		"ESTABLECER <VARIABLE> <VALOR>",
		"VARIABLES",
		"IMPRIMIR",
		"LIMPIAR",
		"SALIR",
	],
]

var commands_idx = -1
var param1_idx = -1
var param2_idx = -1
var numeric_param = 0
var mode_idx = 0
var mode = ["cmd", "param1", "param2"]


var STATUS = {
	"name": "ESTADO",
	"param1": null,
	"param2": null
}
var GAME = {
	"name": "JUEGO",
	"param1": null,
	"param2": null
} 
var HELP = {
	"name": "AYUDA",
	"param1": ["ESTADO", "JUEGO", "LISTAR", "IMPRIMIR", "LIMPIAR", "SALIR"],
	"param2": null
}

var HELP2 = {
	"name": "AYUDA",
	"param1": ["ESTABLECER", "VARIABLES", "IMPRIMIR", "LIMPIAR", "SALIR"],
	"param2": null
}

var SET = {
	"name": "ESTABLECER",
	"param1": [trad_vars(Global.Terminals[terminal_number].variable)],
	"param2": ["SI", "NO"]
}
var VARIABLES = {
	"name": "VARIABLES",
	"param1": null,
	"param2": null
}

var LIST = {
	"name": "LISTAR",
	"param1": null,
	"param2": null
}
var PRINT = {
	"name": "IMPRIMIR",
	"param1": null,
	"param2": null
}
var CLEAR = {
	"name": "LIMPIAR",
	"param1": null,
	"param2": null
}
var EXIT = {
	"name": "SALIR",
	"param1": null,
	"param2": null
}

var terminal_commands = [
	[
		STATUS,
		GAME,
		HELP,
		LIST,
		PRINT,
		CLEAR,
		EXIT,
	],
	[
		HELP2,
		SET,
		VARIABLES,
		PRINT,
		CLEAR,
		EXIT,
	],
	[
		HELP2,
		SET,
		VARIABLES,
		PRINT,
		CLEAR,
		EXIT,
	],
	[
		HELP2,
		SET,
		VARIABLES,
		PRINT,
		CLEAR,
		EXIT,
	],
	[
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
				current_message = "BIENVENIDO A LA GRUTA TERMINAL #" + str(terminal_number) + " " + Global.Terminals[terminal_number].name.strip_edges() + "# \n"
				current_message += "ESCRIBA LOS COMANDOS O USE LAS FLECHAS (↑↓→) PARA INTERACTUAR CON ELLOS\n"
				current_message += "LISTO\n"
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
		var gamepad = event is InputEventJoypadButton
		
		if gamepad:
			if event.is_action_pressed("right"):
				Global.play_sound(Global.TerminalClickSFX)
				if KeyRight():
					KeyUpDown(Key.KEY_UP)
	
			if event.is_action_pressed("up"):
				Global.play_sound(Global.TerminalClickSFX)
				KeyUpDown(Key.KEY_UP)
			if event.is_action_pressed("down"):
				Global.play_sound(Global.TerminalClickSFX)
				KeyUpDown(Key.KEY_DOWN)
			
			elif event.is_action_pressed("jump") or event.is_action_pressed("shoot"):
				Global.play_sound(Global.TerminalClickSFX)
				commands_idx = -1
				param1_idx = -1
				param2_idx = -1
				numeric_param = 0
				mode_idx = 0
				command_ok = true
				command = command.replace(cursor, " ")
				
				parser(command, gamepad)
				command = ""
		else:
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
					
					parser(command, gamepad)
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
					numeric_param = Global.Gold
				
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
		return "NIVEL: " + str(Global.CurrentLevel + 1) + "\n[" + PB_YES.repeat(count) + rest + "]"
		
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
	
func trad_item(it):
	for e in Global.gunz_objs:
		if e.friendly_name.to_upper() == it:
			return e.name.to_upper()
	
func parser(_cmd, gamepad):
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
	if found != -1 and _cmd == "AYUDA":
		if !param1:
			var commands = "\n".join(terminal_commands_with_help[terminal_number])
			current_message = "COMANDOS DISPONIBLES:\n" + commands + "\n"
		else:
			var cmd_found = find_cmd(param1)
			if cmd_found == -1:
				current_message = "COMANDO INVALIDO: ESCRIBE AYUDA <COMANDO> O AYUDA PARA VER COMANDOS" + "\n"
			else:
				if param1 == "COMPRAR":
					current_message = "COMPRAR UN ITEM USANDO G-COINS\n"
					current_message += "USO COMPRAR <ITEM> O COMPRAR <ITEM> <CANTIDAD>\n"
					current_message += "ITEMS:\n"
					for i in BUY_ITEMS:
						current_message += trad_item(i) + "\n"
				elif param1 == "DONAR":
					current_message = "HACE UNA DONACION DE G-COINs\n"
					current_message += "USO DONAR <CANTIDAD>\n"
				elif param1 == "ESTADO":
					current_message = "MUESTRA EL ESTADO DE DONACIONES\n"
				elif param1 == "JUEGO":
					current_message = "CORRE UN JUEGO PARA PASAR EL TIEMPO\n"
				elif param1 == "AYUDA":
					current_message = "ESTE COMANDO\n"
				elif param1 == "LISTAR":
					current_message = "LISTA TERMINALES Y ESTADOS\n"
				elif param1 == "IMPRIMIR":
					current_message = "IMPRIME EL MANUAL DE LA TERMINAL\n"
				elif param1 == "LIMPIAR":
					current_message = "LIMPIA LA VENTANA DE LA TERMINAL\n"
				elif param1 == "SALIR":
					current_message = "SALE DEL MODO CONSOLA\n"
				elif param1 == "ESTABLECER":
					current_message = "ESTABLECE EL VALOR DE UNA VARIABLE (VERDADERO O FALSO)\n"
					current_message += "USO ESTABLECER <VARIABLE> <V OR F>\n"
		
	elif found != -1 and _cmd == "COMPRAR":
		if !param1:
			current_message = "ERROR: USE COMPRAR <ITEM> or COMPRAR <ITEM> <CANTIDAD>\n"
			current_message += "ITEMS:\n"
			for i in BUY_ITEMS:
				current_message += i + "\n"
		elif param1:
			var itm_found =  BUY_ITEMS.find(param1)
			if itm_found == -1:
				current_message = "ERROR: ITEM INVALIDO\n"
				current_message += "ITEMS:\n"
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
					
				if Global.buy_item(trad_item(param1), param2):
					current_message = "TRANSACTION TERMINADA\nLISTO" + "\n"
				else:
					current_message = "ERROR: NO SUFICIENTES G-COINS\nLISTO" + "\n"
		
	elif found != -1 and _cmd == "DONAR":
		if Global.CurrentLevel == Global.GOLD_PER_LEVEL.size() - 1:
			current_message = "ERROR: NO MAS DONACIONES DISPONIBLES\nLISTO" + "\n"
		else:
			if !param1:
				current_message = "ERROR: USE DONAR <CANTIDAD>\n"
			else:
				if !param1.is_valid_int():
					param1 = 1
				else:
					param1 = int(param1)
				
				var result = Global.donate(param1)
				if result != null:
					Global.play_sound(Global.CoinSFX)
					current_message = "¡GRACIAS!\n"
					current_message += "TRANSACTION TERMINADA\n"
					current_message += calc_progress() + "\n"
					current_message += calc_progress_percent() + "\n"
					if result != Global.perks_equiped:
						current_message +=  "\nNUEVOS ITEMS DISPONIBLES:\n"
						for i in range(Global.perks_equiped.size()):
							if i > 0:
								if result[i] == null and Global.perks_equiped[i] != null:
									current_message += "\t. " + Global.perks_equiped[i].friendly_name.to_upper() + "\n"
									current_message += "\t\t" + Global.perks_equiped[i].description + "\n"
					
					await get_tree().create_timer(3.2).timeout
					Global.play_sound(Global.TerminalLevelUPSFX)
					
					current_message +=  "\nLISTO\n"
				else:
					current_message = "ERROR: NO SUFICIENTES G-COINS\nLISTO" + "\n"

	elif found != -1 and _cmd == "LIMPIAR":
		CMD.text = ""
	elif found != -1 and _cmd == "ESTADO":
		current_message = "ESTADO DE DONACIONES: "+ "\n"
		current_message += calc_progress() + "\n"
		current_message += calc_progress_percent() + "\n"
		current_message +=  "LISTO\n"
	elif found != -1 and _cmd == "JUEGO":
		current_message = "INICIANDO..."
		Global.CameFromConsole = true
		await get_tree().create_timer(1.5).timeout
		get_tree().change_scene_to_file("res://scenes/levels/room_retro_game.tscn")
	elif found != -1 and _cmd == "IMPRIMIR":
		Global.play_sound(Global.TerminalPrintSFX)
		current_message = "IMPRIMIENDO...\nLISTO" + "\n"
		$Info.visible = true
		$Info.terminal_number = terminal_number
	elif found != -1 and _cmd == "LISTAR":
		var commands = ""
		for i in range(Global.Terminals.size()):
			commands += "#" + str(i) + " " + Global.Terminals[i].name + "# | ESTADO: " + trad_state(Global.Terminals[i].status) + "\n"
			var vars = trad_vars(Global.Terminals[i].variable)
			if vars != "":
				commands += "\t" + vars+ "\n\n"
		current_message = "LISTA DE TERMINALES:\n" + commands + "\nLISTO" + "\n"
	elif found != -1 and _cmd == "SALIR":
		CMD.text = ""
		$display/Terminal.visible = false
		$display/back.visible = false
		active = false
		opened = false
		Global.player_obj.terminal_mode = false
		Global.player_obj.visible = true
	else:
		current_message = "ERROR: ESCRIBE AYUDA <COMANDO> O AYUDA PARA VER COMANDOS O USE LAS FLECHAS (↑↓→) PARA INTERACTUAR"+ "\n"
		
	if gamepad:
		if current_message:
			current_message = "\n" + current_message
		
		
func trad_vars(val):
	if val != {}:
		var str_ = str(val).replace("{", "").replace("}", "")
		str_= str_.replace("false", "F").replace("true", "V")
		return str_
	else:
		return ""
		
func trad_state(val):
	if val == true:
		return "DISPONIBLE"
	elif val == false:
		return "NO DISPONIBLE"
	elif val == null:
		return "DESCONOCIDO"
			
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
