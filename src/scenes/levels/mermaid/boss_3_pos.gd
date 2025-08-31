extends Node2D

func get_random_point():
	randomize()
	var childs = get_children()
	childs.shuffle()
	var mark = childs.pop_front()
	return mark.global_position
