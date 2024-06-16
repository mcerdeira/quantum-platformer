extends AnimatableBody2D
var where = null
var opened = false
var ttl_total = 1.1
var ttl = ttl_total
var start_on = true

func teleport(pos):
	global_position = pos
	
func _emit():
	Global.emit(global_position, 3)

func _ready():
	add_to_group("moving_platform")
