extends Node2D
var pos_ix = 0
var pos = [0, 22, 44]

func _ready() -> void:
	$sprite.play()
	$sprite.frame = 0
	$sprite2.play()
	$sprite2.frame = 0

func _physics_process(delta: float) -> void:
	if $"../../char".is_ready:
		if Input.is_action_just_pressed("start") or Input.is_action_just_pressed("jump"):
			Global.play_sound(Global.InteractSFX)
			if pos_ix == 0:
				$"..".visible = false
				$"../../NewGame/AnimationPlayer".play("new_animation")
				get_tree().paused = true
			elif pos_ix == 1:
				$"..".visible = false
				$"../../Options/AnimationPlayer".play("new_animation")
				get_tree().paused = true
			elif pos_ix == 2:
				get_tree().quit()
		
		if Input.is_action_just_pressed("down"):
			Global.play_sound(Global.InteractSFX)
			go_down()
		elif Input.is_action_just_pressed("up"):
			Global.play_sound(Global.InteractSFX)
			go_up()

func go_up():
	pos_ix -= 1
	if pos_ix < 0:
		pos_ix = pos.size() - 1
		
	position.y = pos[pos_ix]
	
func go_down():
	pos_ix += 1
	if pos_ix > pos.size() - 1:
		pos_ix = 0
	position.y = pos[pos_ix]
