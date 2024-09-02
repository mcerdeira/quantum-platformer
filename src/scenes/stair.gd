extends Area2D
@export var plant_stair = false
@export var tilemap : TileMap
var stair = 0
var rope = 1
var vine = 2
var whatiam = null
var continuation = false
var child = null

var tiles = [
	[1, 1, 1],
	[4, 5, 6],
	[10, 8, 11],
]

func change_motherfucker(_whatiam):
	if tilemap:
		continuation = true
		whatiam = _whatiam
		define_me()
		if child:
			child.change_motherfucker(whatiam)
			redefine_me()
		
func redefine_me():
	var transf = tiles[whatiam]
	var mult = scale.y
	var pos_calc = Vector2(position.x, position.y - (32 * mult))
	var pos_in_tile = tilemap.local_to_map(pos_calc)
	for i in range(pos_in_tile.y, pos_in_tile.y + mult):
		var idx = 1
		if i == (pos_in_tile.y + mult) - 1:
			tilemap.set_cell(0, Vector2(pos_in_tile.x, i), transf[idx], Vector2(0, 0))
		
func define_me():
	var transf = tiles[whatiam]
	var mult = scale.y
	var pos_calc = Vector2(position.x, position.y - (32 * mult))
	var pos_in_tile = tilemap.local_to_map(pos_calc)
	for i in range(pos_in_tile.y, pos_in_tile.y + mult):
		var idx = 1
		if i == pos_in_tile.y and !continuation:
			idx = 0
		elif i == (pos_in_tile.y + mult) - 1:
			idx = 2
		
		tilemap.set_cell(0, Vector2(pos_in_tile.x, i), transf[idx], Vector2(0, 0))		

func _ready():
	add_to_group("stairs")
	if tilemap:
		whatiam = Global.pick_random([stair, rope, vine])
		define_me()
		
	if plant_stair:
		add_to_group("plant_stair")

func _on_changer_area_entered(area):
	if area.is_in_group("stairs") and area != self:
		child = area
		area.change_motherfucker(whatiam)
		redefine_me()
