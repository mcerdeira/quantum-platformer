extends Node2D
var active_number = 1
var speed = 1

func _ready():
	get_tree().paused = true
		
func _physics_process(delta):
	if Input.is_action_just_pressed("quit"):
		Global.play_sound(Global.InteractSFX)
		get_tree().paused = false
		queue_free()
	elif Input.is_action_just_pressed("jump"):
		Global.play_sound(Global.InteractSFX)
		active_number += 1
		if active_number > 4:
			active_number = 1
	#elif Input.is_action_just_pressed("up"):
		#Global.play_sound(Global.InteractSFX)
		#active_number -= 1
		#if active_number < 1:
			#active_number = 4
			#
	$cositor.global_position = get_node("pos" + str(active_number)).global_position
	if active_number < 3:
		$cositor.scale.y = -1
	else:
		$cositor.scale.y = 1
	
	if Input.is_action_pressed("left"):
		var node = $SubViewport
		node.rotation_set(-speed * delta, active_number)
	elif Input.is_action_pressed("right"):
		var node = $SubViewport 
		node.rotation_set(speed * delta, active_number)
