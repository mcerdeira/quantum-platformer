extends Node
var FULLSCREEN = false
var SAVED_GAME = false
var particle = preload("res://scenes/particle2.tscn")
var MUSIC_ENABLED = true
var MUSIC_PLAYING = false
var MainTheme = "res://music/Bone Yard Waltz - Loopable.ogg"
var JUMP_SFX = null
var CHROM_FX = null
var lava_FX = null
var player_obj = null
var retro_game_high_score = 9000
var SwitchColorActive = "blue"
var LevelCurrentTerminalNumber = -1

var smoke_bomb = {
	"name": "smoke",
	"description": "Smoke bomb!",
	"has_action": true,
	"pasive": false,
	"full_scale": true,
}
var plant = {
	"name": "plant",
	"description": "Grows!",
	"has_action": true,
	"pasive": false,
	"full_scale": true,
}
var clone = {
	"name": "clone",
	"description": "Generates a copy of you.",
	"has_action": true,
	"pasive": false,
	"full_scale": false,
}
var teleport = {
	"name": "teleport",
	"description": "Instant travel through space.",
	"has_action": true,
	"pasive": false,
	"full_scale": false,
}
var muffin = {
	"name": "muffin",
	"description": "Yuummy!",
	"has_action": false,
	"pasive": false,
	"full_scale": false,
}
var bomb = {
	"name": "bomb",
	"description": "Kaboom!",
	"has_action": true,
	"pasive": false,
	"full_scale": true,
}
var radar = {
	"name": "radar",
	"description": "Where is everybody?",
	"has_action": false,
	"pasive": true,
	"full_scale": false,
}
var spring = {
	"name": "spring",
	"description": "Boing! Boing!",
	"has_action": false,
	"pasive": false,
	"full_scale": true,
}
var invisibility = {
	"name": "invisibility",
	"description": "Now you see it, now you don't.",
	"has_action": false,
	"pasive": true,
	"full_scale": false,
}

var none = {
	"name": "none",
	"description": "...",
	"has_action": false,
	"pasive": true,
	"full_scale": false,
}

var gunz_objs = []
var gunz_objs_prob = []
var gunz_equiped = []
var slots_stock = [0, 0]
var gunz_index = 0
var main_camera = null
var targets : Array = []
var time_speed = 1.0
var GAMEOVER = false
var shaker_obj = null
var GizmoWatcher = null
var exit_door = null
var prisoner_counter = 0
var prisoner_total = 0
var bounce_amount = 0.3
var map_obj = null
var commands : Dictionary
var first_time = true
var Fader = null
var TerminalNumber = -1

var LASERS = true
var GHOSTS = true
var WATERFALLS = true
var FIREBALLS = true

var Terminals = [
	{
		"name": "The Eye    ",
		"description" : "The Eye    ",
		"status": true,
		"prisoners": 0,
		"variable" : {}
	},
	{
		"name": "The Leaf   ",
		"description" : "The Leaf   ",
		"status": true,
		"prisoners": 5,
		"variable" : {"LASERS": true}
	},
	{
		"name": "The Tomb   ",
		"description" : "The Tomb   ",
		"status": false,
		"prisoners": 5,
		"variable" : {"GHOSTS": true}
	},
	{
		"name": "The Mermaid",
		"description" : "The Mermaid   ",
		"status": false,
		"prisoners": 7,
		"variable" : {"WATERFALLS": true}
	},
	{
		"name": "The Dragon ",
		"description" : "The Dragon   ",
		"status": false,
		"prisoners": 7,
		"variable" : {"FIREBALLS": true}
	},
	{
		"name": "The S3r4ph ",
		"description" : "The S3r4ph   ",
		"status": null,
		"prisoners": 10,
		"variable" :{"$5&/#/()":null}
	},
]
	
enum GameStates {
	HOME,
	OUTSIDE,
	FALLING,
	OVERWORLD,
	RANDOMLEVEL,
}

var CurrentState : GameStates = GameStates.HOME

func scene_next(terminal_number = -1):
	Global.TerminalNumber = terminal_number
	if Global.CurrentState == Global.GameStates.HOME:
		Global.CurrentState = Global.GameStates.OUTSIDE
	elif Global.CurrentState == Global.GameStates.OUTSIDE:
		Global.CurrentState = Global.GameStates.FALLING
	elif Global.CurrentState == Global.GameStates.FALLING:
		Global.CurrentState = Global.GameStates.OVERWORLD
	elif Global.CurrentState == Global.GameStates.OVERWORLD:
		#TODO: ver en funcion de terminal_number
		Global.LevelCurrentTerminalNumber = terminal_number
		Global.CurrentState = Global.GameStates.RANDOMLEVEL
	elif Global.CurrentState == Global.GameStates.RANDOMLEVEL:
		Global.CurrentState = Global.GameStates.OVERWORLD

	Global.Fader.fade_in()
	get_tree().reload_current_scene()

func remove_item():
	Global.slots_stock[Global.gunz_index] -= 1
	Global.GizmoWatcher.setHUD()

func get_item(current_item):
	var found = false
	for i in range(Global.gunz_equiped.size()): #Try to add stock
		if Global.gunz_equiped[i].name == current_item.name:
			found = true
			slots_stock[i] += 1
			break;
			
	if !found:
		for i in range(Global.gunz_equiped.size()):  #Try to find empty slot 
			if Global.gunz_equiped[i].name == "none":
				Global.gunz_equiped[i] = current_item
				found = true
				slots_stock[i] = 1
				break;
				
	if !found: #If previus fails, override item to current selected
		Global.gunz_equiped[Global.gunz_index] = current_item
		slots_stock[Global.gunz_index] = 1
	
	Global.GizmoWatcher.setHUD()
	
func emit(_global_position, count):
	for i in range(count):
		var p = particle.instantiate()
		p.global_position = _global_position
		add_child(p)
		
func flyaway(direction, jump_speed):
	var velocity = Vector2()
	velocity.x = direction.x * 65.0
	velocity.y = jump_speed * 1.4
	return velocity
	
func save_game():
	var saved_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	saved_game.store_var(Global.CurrentState)
	saved_game.store_var(Global.first_time)
	
	saved_game.store_var(Global.LASERS) #LEAF
	saved_game.store_var(Global.GHOSTS) #TOMB
	saved_game.store_var(Global.WATERFALLS) #MERMAID
	saved_game.store_var(Global.FIREBALLS) #DRAGON
	saved_game.store_var(Global.retro_game_high_score)

	saved_game.close()
	
func load_game():
	var saved_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	if saved_game:
		var cur_state = saved_game.get_var()
		var f_time = saved_game.get_var()
		var lasers = saved_game.get_var()
		var ghosts = saved_game.get_var()
		var waterfalls = saved_game.get_var()
		var fireballs = saved_game.get_var()
		var high_score = saved_game.get_var()
		
		if cur_state != null:
			Global.CurrentState = cur_state
			if Global.CurrentState == Global.GameStates.RANDOMLEVEL:
				#No se puede guardar en un randomlevel
				Global.CurrentState = Global.GameStates.OVERWORLD
			
			Global.first_time = f_time
			if high_score:
				Global.retro_game_high_score = high_score
			if lasers != null:
				Global.LASERS = lasers
			if ghosts != null:
				Global.GHOSTS = ghosts
			if waterfalls != null:
				Global.WATERFALLS = waterfalls
			if fireballs != null:
				Global.FIREBALLS = fireballs

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
	prisoner_counter = 0
	prisoner_total = 0
	map_obj = null
	gunz_objs = []
	commands = {}
	gunz_objs.append(clone)
	gunz_objs.append(teleport)
	gunz_objs.append(muffin)
	gunz_objs.append(bomb)
	gunz_objs.append(radar)
	gunz_objs.append(spring)
	gunz_objs.append(invisibility)
	gunz_objs.append(plant)
	
	gunz_objs_prob = [] + gunz_objs
	for i in range(5):
		gunz_objs_prob.append(muffin)
		gunz_objs_prob.append(bomb)
		gunz_objs_prob.append(spring)
	
	gunz_equiped = [none, none]
	
	#DEBUG
	#slots_stock = [2, 0]
	#gunz_equiped[0] = smoke_bomb
	
	randomize()
	
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
