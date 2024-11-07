extends Area2D
@export var terminal_number = -1
var active = false
var opened = false
var player = null
var delay_camera = 0.2

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
			Global.play_sound(Global.InteractSFX)
			opened = true
			active = false
			$back.visible = false
			$InfoDisplay.visible = true
			Global.emit(global_position, 5)

func _on_body_entered(body):
	if !opened and body.is_in_group("players") and !body.is_in_group("prisoners"):
		body.dont_camera = true
		$back.visible = true
		$InfoDisplay.visible = false
		active = true
		player = body

func _on_body_exited(body):
	if body.is_in_group("players") and !body.is_in_group("prisoners"):
		body.dont_camera = false
		$back.visible = false
		$InfoDisplay.visible = false
		active = false
		opened = false
		body.dont_camera = false
