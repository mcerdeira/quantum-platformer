extends Area2D
var parent = null 

func _ready():
	parent = get_parent()

func _process(delta):
	var areas = get_overlapping_areas()
	for a in areas:
		if a.is_in_group("stairs"):
			parent.is_on_stairs = true
			return
			
	parent.is_on_stairs = false
	parent.grabbed = false
