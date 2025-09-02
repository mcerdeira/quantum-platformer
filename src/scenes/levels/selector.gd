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
		if Input.is_action_just_pressed("down"):
			go_down()
		elif Input.is_action_just_pressed("up"):
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
