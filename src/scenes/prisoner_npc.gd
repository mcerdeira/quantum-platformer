extends Area2D
var active = false
var opened = false
var player = null
var delay_camera = 0.2
var current_message = ""
var ttl = 0

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
	
	if active and !opened:
		if Input.is_action_just_pressed("up"):
			opened = true
			active = false
			Global.emit(global_position, 5)
			$back/sprite.animation = "prisoner"
			$back/sprite.play()
			current_message = "They kidnapped my friends!! (and your 'dog')"
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
		body.dont_camera = false
		$back.visible = false
		active = false
		body.dont_camera = false

