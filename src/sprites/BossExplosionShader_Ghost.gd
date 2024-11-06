extends Node2D
var ttl = 1.3
var forward = true
var CinematicPos = null
var current_message = ""
var current_message_count = 0
var current_messages = []
var end_ttl = 5
var change_ttl = 0
var dialog_sfx = null
var cinematic = false

func _ready():
	for i in range(20):
		current_messages.append("")
		
	current_message = "?????????"
	current_messages[17] = "¡MOMENTO! Yo soy un fantasma... No puedo morir..."
	current_messages[16] = "(...)"
	current_messages[15] = "¿¿¿POR QUE PROFANASTE TODAS MIS TUMBAS???"
	current_messages[14] = "(...)"
	current_messages[13] = "¿¿PARA HACERME SALIR?? ¡¡¡ME HUBIERAS PREGUNTADO!!!"
	current_messages[12] = "(estos jovenes de hoy...)"
	current_messages[11] = "De tu mascota lo que se es que estuvo, si..."
	current_messages[10] = "Pero se asusto y se fue para la zona de las cascadas."
	current_messages[9] = "(...)"
	current_messages[8] = "O eso me parecio ver."
	current_messages[7] = "Te voy a abrir la puerta de esa zona asi podes ir a ver."
	current_messages[6] = "Lo que si te advierto, esta muy inundado todo, es un peligro."
	current_messages[5] = "(...)"
	current_messages[4] = "No tuve tiempo de llamar a un plomero, un lio..."
	current_messages[3] = "(...)"
	current_messages[2] = "¿¿COMO?? ¿¿¿No sabes como volver???"
	current_messages[1] = "(>_<)"
	current_messages[0] = "En fin... te indico por donde ir..., ¿Ves aquella tuberia?"	
	current_message_count = 18

func _physics_process(delta):
	if !cinematic:
		if ttl > 0:
			ttl -= 1 * delta
			if ttl <= 0:
				start()
	else:
		if change_ttl > 0:
			change_ttl -= 1 * delta
			if change_ttl <= 0:
				$back/lbl_item.text = ""
				dialog_sfx = Global.play_sound(Global.DialogSFX)
			return
				
		$back2.visible = $back.visible 
		if !current_message:
			end_ttl -= 1 * delta
			if end_ttl <= 0:
				Global.scene_next(Global.TerminalNumber, false)
						
		if current_message:
			ttl -= 1 * delta
			if ttl <= 0:
				ttl = 0.05
				$back/lbl_item.text += current_message.substr(0, 1)
				current_message = current_message.substr(1, current_message.length() - 1)
				if !current_message:
					current_message_count -= 1
					if current_message_count < 0:
						Global.kill(dialog_sfx)
						Global.player_obj.dont_camera = false
						await get_tree().create_timer(1.3).timeout
						$back.visible = false
					else:
						Global.kill(dialog_sfx)
						current_message = current_messages[current_message_count]
						change_ttl = 1.3
func start():
	$AnimationPlayer.play("new_animation")	
	Global.play_sound(Global.BOSS1RoarSFX)
	Ambience.play(Global.CaveAmbienceSFX)

func _on_animation_player_animation_finished(anim_name):
	if forward:
		forward = false
		$Timer.start()

func _on_timer_timeout():
	global_position = CinematicPos.global_position
	$AnimationPlayer.play_backwards("new_animation")
	cinematic = true
