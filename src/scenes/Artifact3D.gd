extends Node2D
var active_number = 1
var moving = false

func _ready():
	Global.PauseStop = true
	get_tree().paused = true
		
func _physics_process(delta):
	if !moving:
		if Input.is_action_just_pressed("quit") or Input.is_action_just_pressed("start") or Input.is_action_just_pressed("quit_soft"):
			Global.play_sound(Global.InteractSFX)
			get_tree().paused = false
			if Global.combinatoryOK and !Global.BoatUnlocked:
				Global.BoatUnlocked = true
				Global.BoatObj.activate()
				
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
			var node = $SubViewport
			moving = true
			await node.rotation_set(-1, active_number).finished
			bounds_check()
			moving = false
			$SubViewport.evaluateCombi()
		elif Input.is_action_just_pressed("right"):
			var node = $SubViewport 
			moving = true
			await node.rotation_set(1, active_number).finished
			bounds_check()
			moving = false
			$SubViewport.evaluateCombi()

func bounds_check():
	var node3d = get_node("SubViewport/Node3D/art3d_part" + str(active_number))
	if node3d.rotation_degrees.y == 360:
		node3d.rotation_degrees.y = 0
	if node3d.rotation_degrees.y == -90:
		node3d.rotation_degrees.y = 270
