extends AnimatedSprite2D
var last_target = null
var target = null 
var parent = null
var activation_ttl = 0 

func _ready():
	parent = get_parent()
	
func activate(val):
	if Global.CurrentState == Global.GameStates.RANDOMLEVEL:
		visible = val
		activation_ttl = 1.3
		Global.emit(global_position, 50)

func _process(delta):
	if visible:
		if activation_ttl > 0:
			activation_ttl -= 1 * delta
			rotation += 10 * delta
			if activation_ttl <= 0:
				Global.emit(global_position, 10)
			return
			
		if Global.exit_door:
			look_at(Global.exit_door.global_position)
