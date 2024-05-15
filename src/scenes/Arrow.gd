extends AnimatedSprite2D
var last_target = null
var target = null 
var parent = null
var activation_ttl = 0 

func _ready():
	parent = get_parent()
	
func activate(val):
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
			
		if !Global.exit_door.closed:
			look_at(Global.exit_door.global_position)
			return
		
		var last_distance = 90000000000
		var targets = get_tree().get_nodes_in_group("prisoners")
		var found = false
		for t in targets:
			if t.trapped:
				var dist = t.global_position.distance_to(parent.global_position)
				if dist < last_distance:
					found = true
					last_distance = dist
					target = t
		if found:
			animation = "default"
			if target != last_target and last_target != null:
				activation_ttl = 1.3
			
			look_at(target.global_position)
			last_target = target
		else:
			Global.emit(global_position, 10)
			rotation = 0
			animation = "notfound"

