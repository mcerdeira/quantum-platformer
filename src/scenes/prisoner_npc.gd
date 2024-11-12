extends Area2D
var active = false
var opened = false
var player = null
var delay_camera = 0.2
var current_message = ""
var current_message_count = 0
var current_messages = []
var ttl = 0
var dialog_sfx = null
@export var boss_1_npc = false
@export var uncle = false
var end_ttl = 5
var change_ttl = 0

func _ready():
	for i in range(20):
		current_messages.append("")

func _physics_process(delta):
	if change_ttl > 0:
		change_ttl -= 1 * delta
		if change_ttl <= 0:
			$back/lbl_item.text = ""
			dialog_sfx = Global.play_sound(Global.DialogSFX)
		return
	
	if boss_1_npc:
		if Global.CurrentState == Global.GameStates.SHOP:
			if !Global.TOMB_STATUS and !Global.MERMAID_STATUS and !Global.SALAMANDER_STATUS and !Global.SERAPH_STATUS:
				queue_free()
			
		$Timer.stop()
		$Computer.animation = "boss1"
		$Computer/cry.animation = "boss1"
		
	if uncle:
		if Global.TOMB_STATUS or Global.MERMAID_STATUS or Global.SALAMANDER_STATUS or Global.SERAPH_STATUS:
			$Computer.animation = "uncle"
			$Computer/cry.animation = "boss1"
		else:
			queue_free()
	
	$back2.visible = $back.visible 
	if !active and opened:
		if !current_message:
			end_ttl -= 1 * delta
			if end_ttl <= 0:
				if boss_1_npc and Global.CurrentState != Global.GameStates.SHOP:
					Global.scene_next(Global.TerminalNumber, false, false, false, true)
		
		if player:
			if delay_camera > 0:
				delay_camera -= 1 * delta
				if delay_camera <= 0:
					player.dont_camera = false
					
	if current_message:
		ttl -= 1 * delta
		if ttl <= 0:
			ttl = 0.05
			$back/lbl_item.text += current_message.substr(0, 1)
			current_message = current_message.substr(1, current_message.length() - 1)
			if !current_message:
				current_message_count -= 1
				if current_message_count < 0:
					Global.player_obj.locked_ctrls = false
					Global.kill(dialog_sfx)
					Global.player_obj.dont_camera = false
					active = false
					await get_tree().create_timer(1.3).timeout
					$back.visible = false
				else:
					Global.kill(dialog_sfx)
					current_message = current_messages[current_message_count]
					change_ttl = 1.3
	
	if active and !opened:
		if Input.is_action_just_pressed("up"):
			Global.player_obj.locked_ctrls = true
			Global.play_sound(Global.InteractSFX)
			opened = true
			active = false
			Global.emit(global_position, 5)
			if boss_1_npc:
				$Computer.animation = "boss1"
				$Computer/cry.animation = "boss1"
				if Global.CurrentState == Global.GameStates.SHOP:
					$back/sprite.animation = "shop"
				elif Global.CurrentState == Global.GameStates.OVERWORLD:
					$back/sprite.animation = "prisoner_1"
				else:
					$back/sprite.animation = "boss1"
					$back/sprite.scale.x = 0.1
					$back/sprite.scale.y = 0.1
			else:
				$back/sprite.animation = "prisoner"
				
			$back/sprite.play()
			dialog_sfx = Global.play_sound(Global.DialogSFX)
			if boss_1_npc:
				if Global.CurrentState == Global.GameStates.SHOP:
					if uncle:
						current_message = "BIENVENIDO A LA TIENDA: TIO&SOBRINO"
						current_messages[1] = "¡Gracias por salvar a mi sobrino!"
						current_messages[0] = "En agradecimiento... ¡Te damos un descuento en todos los items!"
						current_message_count = 2
					else:
						current_message = "BIENVENIDO A LA TIENDA: TIO&SOBRINO"
						if Global.TOMB_STATUS:
							current_messages[6] = "¡Gracias de nuevo!"
							current_messages[5] = "¿Pudiste ir al cementerio como te dije?"
							current_messages[4] = "(...)"
							current_messages[3] = "(miedoso)"
							current_messages[2] = "Solo por ser vos... te dejamos usar la compu."
							current_messages[1] = "Tiene muchas cosas que no sabemos que son..."
							current_messages[0] = "¡Y un video juego genial!"
							current_message_count = 7
						else:
							current_messages[3] = "¡Gracias de nuevo!"
							current_messages[2] = "Solo por ser vos... te dejamos usar la compu."
							current_messages[1] = "Tiene muchas cosas que no sabemos que son..."
							current_messages[0] = "¡Y un video juego genial!"
							current_message_count = 4
						
				elif Global.CurrentState == Global.GameStates.OVERWORLD:
					current_message = "Bueno... llegamos..."
					current_messages[17] = "(...)"
					current_messages[16] = "¡Interesante viaje!"
					current_messages[15] = "Me preocupe un poco cuando aparecio el monstruo serpiente..."
					current_messages[14] = "Pero bueno, ya ambos sabemos la historia."
					current_messages[13] = "De alguna forma matar al bicho horrendo"
					current_messages[12] = "hizo que la puerta del cementerio se abra..."
					current_messages[11] = "El fantasmote que vive ahi siempre esta enterado de todo."
					current_messages[10] = "Podríamos preguntarle a el... el unico problema es..."
					current_messages[9] = "que no le gusta salir demasiado..."
					current_messages[8] = "(...)"
					current_messages[7] = "¡YA SE! Por que no te adentras al cementerio y..."
					current_messages[6] = "profanas algunas tumbas, no son tantas..."
					current_messages[5] = "¡Estoy seguro que asi lo haremos salir!"
					current_messages[4] = "MI PLAN NO TIENE FALLAS"
					current_messages[3] = "(...)"
					current_messages[2] = "(espero que no se enoje mucho)"
					current_messages[1] = "(...)"
					current_messages[0] = "Eso es todo, ¡si podes pasa por la tienda de mi tio!"
					current_message_count = 18
				else:
					current_message = "¡GRACIAS! El bicho este horrible me había comido, fue un asco..."
					current_messages[6] = "Lamentablemente, tu mascota no está acá..."
					current_messages[5] = "Pasa por la tienda de mi tio, quiza te podamos ayudar."
					current_messages[4] = "(...)"
					current_messages[3] = "¿¿COMO?? ¿¿¿No sabes como volver???"
					current_messages[2] = "(¿como llego aca en primer lugar?)"
					current_messages[1] = "(...)"
					current_messages[0] = "Bueno, veni conmigo que te ayudo a volver..."
					
					current_message_count = 7
			else:
				current_message = "¡La  G R U T A  se llevo a mis amigos y a tu perro!"
				current_messages[0] = "¡¡BUAAA!! ¡¡BUAAA!!"
				current_message_count = 1
			$back/lbl_item.text = ""
			$back/arrows.visible = false

func _on_body_entered(body):
	if !opened and body.is_in_group("players") and !body.is_in_group("prisoners"):
		body.dont_camera = true
		$back.visible = true
		active = true
		player = body

func _on_body_exited(body):
	if body.is_in_group("players") and !body.is_in_group("prisoners"):
		if !opened or (opened and current_message == ""):
			body.dont_camera = false
			$back.visible = false
			active = false

func _on_timer_timeout():
	if !boss_1_npc:
		$Timer.wait_time = Global.pick_random([2, 3, 4])
		var options = {"pitch_scale": Global.pick_random([1, 0.7, 1.1])}
		Global.play_sound(Global.CryingSFX, options, global_position)
