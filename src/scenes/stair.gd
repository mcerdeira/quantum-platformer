extends Area2D
@export var plant_stair = false
@export var tilemap : TileMap
var stair = 1
var rope = 5
var vine = 8

func _ready():
	if tilemap:
		var transf = Global.pick_random([stair, rope, vine])
		
		var mult = scale.y
		var pos_calc = Vector2(position.x, position.y - (32 * mult))
		var pos_in_tile = tilemap.local_to_map(pos_calc)
		for i in range(pos_in_tile.y, pos_in_tile.y + mult):
			tilemap.set_cell(0, Vector2(pos_in_tile.x, i), transf, Vector2(0, 0))
		
	add_to_group("stairs")
	if plant_stair:
		add_to_group("plant_stair")
