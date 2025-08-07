extends Area2D
var ringing = false
var active = false
var opened = false
var player = null
var delay_camera = 0.2
var current_message = ""
var ttl = 0
@export var Door : Area2D
var dialog_sfx = null
var ring_sfx = null

func _on_timer_timeout():
	if !opened:
		if $Timer.wait_time != 2.5:
			$Timer.stop()
			$Timer.wait_time = 2.5
			$Timer.start()
			
		if !ringing:
			ringing = true
			ring_sfx = Global.play_sound(Global.TelephoneRingSFX)
			$AnimationPlayer.play("new_animation")
			$Computer.play()
		else:
			ringing = false
			$AnimationPlayer.stop()
			$Computer.stop()
			
func stop_ringing():
	$Timer.stop()
			
func _physics_process(delta):
	$back2.visible = $back.visible 
	if !active and opened:
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
				Global.player_obj.locked_ctrls = false
				Global.kill(dialog_sfx)
				Global.player_obj.dont_camera = false
				active = false
				await get_tree().create_timer(1.3).timeout
				$back.visible = false
	
	if active and !opened:
		if Input.is_action_just_pressed("up"):
			Global.kill(ring_sfx)
			Global.play_sound(Global.InteractSFX)
			Global.play_sound(Global.TelephoneUpSFX)
			opened = true
			active = false
			Global.emit(global_position, 5)
			$back/sprite.animation = "prisoner"
			$back/sprite.play()
			$back/lbl_item.text = ""
			current_message = "GUAU!! GUAU!! GUAU!!!\nAYUDA!! AYUDA!! AYUDA!!"
			dialog_sfx = Global.play_sound(Global.DialogSFX)
			$back/arrows.visible = false
			ringing = false
			$AnimationPlayer.stop()
			$Computer.stop()
			Door.open()

func _on_body_entered(body):
	if !opened and body.is_in_group("players") and !body.is_in_group("prisoners"):
		body.dont_camera = true
		body.locked_ctrls = true
		$back.visible = true
		active = true
		player = body

func _on_body_exited(body):
	if body.is_in_group("players") and !body.is_in_group("prisoners"):
		if !opened or (opened and current_message == ""):
			body.dont_camera = false
			$back.visible = false
			active = false
