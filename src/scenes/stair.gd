extends Area2D
@export var plant_stair = false
@export var tilemap : TileMap
var stair = 0
var rope = 1
var vine = 2

var tiles = [
	[1, 1, 1],
	[4, 5, 6],
	[10, 8, 11],
]

func _ready():
	if tilemap:
		var _tile = Global.pick_random([stair, rope, vine])
		var transf = tiles[_tile]
		
		var mult = scale.y
		var pos_calc = Vector2(position.x, position.y - (32 * mult))
		var pos_in_tile = tilemap.local_to_map(pos_calc)
		for i in range(pos_in_tile.y, pos_in_tile.y + mult):
			var idx = 1
			if i == pos_in_tile.y:
				idx = 0
			elif i == (pos_in_tile.y + mult) - 1:
				idx = 2
			
			tilemap.set_cell(0, Vector2(pos_in_tile.x, i), transf[idx], Vector2(0, 0))
		
	add_to_group("stairs")
	if plant_stair:
		add_to_group("plant_stair")
