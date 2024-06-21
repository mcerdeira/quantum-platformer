extends TileMap
var q = 0

func _ready():
	Global.save_game()

func delete_player():
	$player_marker.nope = true
	
func delete_door():
	$ExitDoor.nope = true
	$ExitDoor.queue_free()
