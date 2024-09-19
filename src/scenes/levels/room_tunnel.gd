extends TileMap
var tunnel_obj = load("res://scenes/levels/tunnel.tscn")
var q = 0
var ttl = 10

func delete_player():
	pass
	
func delete_door():
	pass
	
func _physics_process(delta):
	ttl -= 1 * delta
	if ttl <= 0:
		ttl = 100 
		Ambience.stop()
		Global.CurrentState = Global.GameStates.OVERWORLD
		Global.scene_next(Global.LevelCurrentTerminalNumber)

func _ready():
	Global.Fader.fade_out()
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
