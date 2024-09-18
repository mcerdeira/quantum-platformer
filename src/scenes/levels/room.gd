extends TileMap
var q = 0

func _ready():
	Global.save_game()
	if !Global.BOSS_ROOM:
		Music.play(Global.MainTheme)

func delete_player():
	$player_marker.nope = true
	
func assign_door(_terminal_number):
	$ExitDoor.assign(_terminal_number)
	
func delete_door():
	$ExitDoor.nope = true
	$ExitDoor.queue_free()
