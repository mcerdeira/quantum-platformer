extends Node
var FULLSCREEN = false
var SAVED_GAME = false
var particle = preload("res://scenes/particle2.tscn")
var MUSIC_ENABLED = true
var MUSIC_PLAYING = false
var MainTheme = "res://music/Bone Yard Waltz - Loopable.ogg"
var JUMP_SFX = null
var gunz = ["clone", "teleport", "rock", "bomb", "radar"]
var gunz_equiped = []
var gunz_index = 0
var main_camera = null
var targets : Array = []
var time_speed = 1.0
var GAMEOVER = false
var shaker_obj = null
var level_doors = []
var GizmoWatcher = null
var exit_door = null
var prisoner_counter = 0
var prisoner_total = 0
var bounce_amount = 0.3
var map_obj = null

func emit(_global_position, count):
	for i in range(count):
		var p = particle.instantiate()
		add_child(p)
		p.global_position = _global_position
		
func flyaway(direction, jump_speed):
	var velocity = Vector2()
	velocity.x = direction.x * 65.0
	velocity.y = jump_speed * 1.4
	return velocity
	
func find_master():
	var master_found = false
	for player in Global.targets:
		if player.dead == false and player.iam_clone == false:
			master_found = true
			
	if !master_found:
		if Global.targets.size() > 0:
			for player in Global.targets:
				if player.dead == false and player.iam_clone == true:
					player.iam_clone = false
					break

func save_game():
	pass
#	var saved_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
#	saved_game.store_var(Global.LEVEL)
#	saved_game.close()
#
#	var saved_poss = FileAccess.open("user://savepos.save", FileAccess.WRITE)
#	saved_poss.store_var(Global.POSSESSIONS)
#	saved_poss.close()
	
func load_game():
	pass
#	var saved_game = FileAccess.open("user://savegame.save", FileAccess.READ)
#	PLAY_INTRO = !saved_game
#	if saved_game:
#		var level = saved_game.get_var()
#		if level:
#			SAVED_GAME = true
#			Global.LEVEL = level
#			saved_game.close()
#
#	var saved_poss = FileAccess.open("user://savepos.save", FileAccess.READ)
#	if saved_poss:
#		var pos = saved_poss.get_var()
#		if pos:
#			Global.POSSESSIONS = pos
#			saved_poss.close()

func _ready():
	load_sfx()
	load_game()
	init()
	
func load_sfx():
	pass
	
func init():
	gunz_equiped = []
	gunz_index = 0
	main_camera = null
	targets = []
	time_speed = 1.0
	GAMEOVER = false
	level_doors = []
	prisoner_counter = 0
	prisoner_total = 0
	map_obj = null
	
	randomize()
	var _gunz = [] + gunz
	for i in range(2):
		_gunz.shuffle()
		gunz_equiped.append(_gunz.pop_front())

func pick_random(container):
	if typeof(container) == TYPE_DICTIONARY:
		return container.values()[randi() % container.size() ]
	assert( typeof(container) in [
			TYPE_ARRAY, TYPE_PACKED_COLOR_ARRAY, TYPE_PACKED_INT32_ARRAY,
			TYPE_PACKED_BYTE_ARRAY, TYPE_PACKED_FLOAT32_ARRAY, TYPE_PACKED_STRING_ARRAY,
			TYPE_PACKED_VECTOR2_ARRAY, TYPE_PACKED_VECTOR3_ARRAY
			], "ERROR: pick_random" )
	return container[randi() % container.size()]

func play_sound(stream: AudioStream, options:= {}) -> AudioStreamPlayer:
	var audio_stream_player = AudioStreamPlayer.new()

	add_child(audio_stream_player)
	audio_stream_player.stream = stream
	audio_stream_player.bus = "SFX"
	
	for prop in options.keys():
		audio_stream_player.set(prop, options[prop])
	
	audio_stream_player.play()
	audio_stream_player.finished.connect(kill.bind(audio_stream_player))
	
	return audio_stream_player
	
func kill(_audio_stream_player):
	_audio_stream_player.queue_free()
