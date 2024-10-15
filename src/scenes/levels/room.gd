extends TileMap
var q = 0

func _ready():
	Global.save_game()

func delete_player():
	$player_marker.nope = true
	
func assign_door(_terminal_number):
	$ExitDoor.assign(_terminal_number)
	
func delete_door():
	$ExitDoor.nope = true
	$ExitDoor.queue_free()
	
func delete_bicho():
	$BichoFeo.queue_free()
