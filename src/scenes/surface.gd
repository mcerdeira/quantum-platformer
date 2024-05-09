extends Sprite2D

class_name paint

var bloods = []
var blood_texture =  preload("res://sprites/blood1.png")

func _ready() -> void:
	pass
	
func draw_blood(draw_pos : Vector2):
	bloods.append(draw_pos)
	queue_redraw()
		
func _draw():
	for b in bloods:
		draw_texture(blood_texture, b)	
	
