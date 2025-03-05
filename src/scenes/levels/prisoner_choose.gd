extends Node2D

func _ready():
	if randi() % 2 == 0:
		var ps = get_children()
		ps.shuffle()
		var selected =  ps.pop_back()
		selected.done = true
		for p in ps:
			p.queue_free()
	else:
		queue_free()
