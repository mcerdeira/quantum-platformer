extends Area2D
var ringing = false
var active = false
var opened = false
var player = null
var delay_camera = 0.2
@export var Door : Area2D

func _on_timer_timeout():
	if !opened:
		if !ringing:
			ringing = true
			$AnimationPlayer.play("new_animation")
			$Computer.play()
		else:
			ringing = false
			$AnimationPlayer.stop()
			$Computer.stop()

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
			$back/sprite.animation = "prisoner"
			$back/sprite.play()
			$back/lbl_item.text = "WOOF!! WOOF!! WOOF!!!\nHELP!! HELP!! HELP!!!"
			$back/arrows.visible = false
			ringing = false
			$AnimationPlayer.stop()
			$Computer.stop()
			Door.open()

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
