extends TileMap
var q = 0
@export var pre_final_scene = false

func _ready():
	Global.save_game()
	if pre_final_scene:
		if Global.AlreadySEEN:
			$player_marker.queue_free()
		else:
			$player_marker2.queue_free()
	
func thunder_sound():
	Global.play_sound(Global.ThunderSFX)

func delete_player():
	if $player_marker:
		$player_marker.nope = true
	
func assign_door(_terminal_number):
	if $ExitDoor:
		$ExitDoor.assign(_terminal_number)
	
func delete_door():
	if $ExitDoor:
		$ExitDoor.nope = true
		$ExitDoor.queue_free()
	
func deletelimit1():
	$level_limtit.queue_free()
	
func deletelimit2():
	$level_limtit2.queue_free()
	
func delete_bicho():
	$BichoFeo.queue_free()
