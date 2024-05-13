extends AnimatedSprite2D
var target = null 
var parent = null
var last_distance = 90000000000
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
			return
		
		var targets = get_tree().get_nodes_in_group("prisoners")
		var found = false
		for t in targets:
			if t.trapped:
				var dist = t.global_position.distance_to(parent.global_position)
				if dist < last_distance:
					found = true
					dist = last_distance
					target = t
		if found:
			animation = "default"
			look_at(target.global_position)
		else:
			rotation = 0
			animation = "notfound"

