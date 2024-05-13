extends Sprite2D

class_name paint

var bloods_temp = []  
var bloods = []
var blood_texture =  preload("res://sprites/blood1.png")
var blood_limit = 10000

func clear_temps():
	bloods_temp = []
	queue_redraw()
	
func draw_blood_temp(draw_pos : Vector2):
	bloods_temp.append(draw_pos)
	queue_redraw()
	
func draw_blood(draw_pos : Vector2):
	if bloods.size() > blood_limit:
		bloods.pop_back()
		bloods.push_front(draw_pos)
	else:
		bloods.append(draw_pos)
	queue_redraw()
		
func _draw():
	for b in bloods_temp:
		draw_texture(blood_texture, b)	
	
	for b in bloods:
		draw_texture(blood_texture, b)	
	
