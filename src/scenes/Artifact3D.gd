extends Node2D
var active_number = 1
var moving = false

func _ready():
	Global.PauseStop = true
	get_tree().paused = true
		
func _physics_process(delta):
	if !moving:
		if Input.is_action_just_pressed("quit"):
			Global.play_sound(Global.InteractSFX)
			get_tree().paused = false
			queue_free()
		elif Input.is_action_just_pressed("jump"):
			Global.play_sound(Global.InteractSFX)
			active_number += 1
			if active_number > 4:
				active_number = 1
				
		$cositor.global_position = get_node("pos" + str(active_number)).global_position
		if active_number < 3:
			$cositor.scale.y = -1
		else:
			$cositor.scale.y = 1
		
		if Input.is_action_just_pressed("left"):
			moving = true
			var node = $SubViewport
			await node.rotation_set(-1, active_number).finished
			moving = false
		elif Input.is_action_just_pressed("right"):
			moving = true
			var node = $SubViewport 
			await node.rotation_set(1, active_number).finished
			moving = false
