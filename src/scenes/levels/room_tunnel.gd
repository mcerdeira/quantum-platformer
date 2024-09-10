extends TileMap
var tunnel_obj = load("res://scenes/levels/tunnel.tscn")

func _ready():
	Global.save_game()
	var calc_depth = 1.0
	var color = 1.0 
	var rspeed = 10.0
	var index = 0
	for i in range(25):
		var tunnel_i = tunnel_obj.instantiate()
		
		calc_depth -= 0.05
		color -= 0.06
		rspeed -= 1.0
		index -= 1
		
		tunnel_i.scale.x = calc_depth
		tunnel_i.scale.y = calc_depth
		tunnel_i.rotate_speed = rspeed
		tunnel_i.z_index = index
		
		tunnel_i.modulate = Color(color, color, color, 1)
		add_child(tunnel_i)
