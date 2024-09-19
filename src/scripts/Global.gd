extends Node
var FULLSCREEN = false
var SAVED_GAME = false
var particle = preload("res://scenes/particle2.tscn")
var MUSIC_ENABLED = true
var MUSIC_PLAYING = false
var CHROM_FX = null
var lava_FX = null
var player_obj = null
var retro_game_high_score = 9000
var SwitchColorActive = "blue"
var LevelCurrentTerminalNumber = -1
var DestructibleID = 9
var DestructedID = 2
var BurnableID = 4
var BurnedID = 5
var CameFromConsole = false
var fade_finished = false
var BOSS_ROOM = false
var FirstDeath = true
var OverWorldFromGameOver = false
var TunnelTerminalNumber = false
var boss_bar = null

var MainTheme = null
var MainThemeShort = null
var BossTheme = null
var CaveAmbienceSFX = null 
var HouseAmbienceSFX = null
var ExteriorAmbienceSFX = null
var FallingAmbienceSFX = null

var PressStartSFX = null
var InteractSFX = null
var TelephoneRingSFX = null
var TelephoneUpSFX = null
var TelevisionOnSFX = null
var CryingSFX = null
var DialogSFX = null
var JumpSFX = null
var WalkSFX = null
var ClimbSFX = null
var FallSFX = null
var BigFallSFX = null
var EnemyJumpSFX = null
var Boss1JumpSFX = null
var BOSS1RoarSFX = null
var EnemyEatingSFX = null
var EnemyKillingSFX = null
var EnemyEaterAlertedSFX = null
var SpringSFX = null
var TerminalONSFX = null
var TerminalPrintSFX = null
var TerminalLevelUPSFX = null
var ChestOpenSFX = null
var PlantSFX = null
var Plant2SFX = null
var ChainsSFX = null
var FallInWellSFX = null
var BombSFX = null
var BombTicSFX = null
var SmokeBombSFX = null
var PlantGrowSFX = null
var CloneSFX = null
var TeleportSFX = null
var MuffinSFX = null
var CoinSFX = null
var MapSFX = null
var RadarSFX = null
var ResurrectSFX = null
var BinocularSFX = null

#CHEST ITEMS 
var smoke_bomb = {
	"name": "smoke",
	"friendly_name": "Bomba de Humo",
	"description": "Los enemigos no te veran.",
	"has_action": true,
	"pasive": false,
	"full_scale": true,
}
var plant = {
	"name": "plant",
	"friendly_name": "Plantita",
	"description": "¡Crece y crece!",
	"has_action": true,
	"pasive": false,
	"full_scale": true,
}
var clone = {
	"name": "clone",
	"friendly_name": "Clonador",
	"description": "Genera una copia tuya.",
	"has_action": true,
	"pasive": false,
	"full_scale": false,
}
var teleport = {
	"name": "teleport",
	"friendly_name": "Teletransportador",
	"description": "Viaje instantaneo en el espacio.",
	"has_action": true,
	"pasive": false,
	"full_scale": false,
}

var spikeball = {
	"name": "spikeball",
	"friendly_name": "Bola Pinchuda",
	"description": "¡Ouch!",
	"has_action": false,
	"pasive": false,
	"full_scale": true,
}

var muffin = {
	"name": "muffin",
	"friendly_name": "Golosina",
	"description": "¡Que rico!",
	"has_action": false,
	"pasive": false,
	"full_scale": false,
}
var bomb = {
	"name": "bomb",
	"friendly_name": "Bomba",
	"description": "¡Bum!",
	"has_action": true,
	"pasive": false,
	"full_scale": true,
}
var coin = {
	"name": "coin",
	"friendly_name": "Moneda",
	"description": "Gruta-Monedas",
	"has_action": false,
	"pasive": true,
	"full_scale": false,
}
var spring = {
	"name": "spring",
	"friendly_name": "Resorte",
	"description": "¡Toing! ¡Toing!",
	"has_action": false,
	"pasive": false,
	"full_scale": true,
}

#PASIVE ITEMS 
var radar = {
	"name": "radar",
	"friendly_name": "Radar",
	"description": "Apunta a la salida. Presiona 'R' para acceder.",
	"has_action": false,
	"pasive": true,
	"full_scale": false,
}
var map = {
	"name": "map",
	"friendly_name": "Mapa",
	"description": "Presiona 'M' para acceder.",
	"has_action": false,
	"pasive": true,
	"full_scale": false,
}
var double_jump = {
	"name": "wings",
	"description": "¡Volar!",
	"has_action": false,
	"pasive": true,
	"full_scale": false,
}
var resurrect = {
	"name": "resurrect",
	"friendly_name": "Resureccion",
	"description": "Un intento más.",
	"has_action": false,
	"pasive": true,
	"full_scale": false,
}
var invisibility = {
	"name": "invisibility",
	"friendly_name": "Invisibilidad",
	"description": "Ahora me ves, ahora no.",
	"has_action": false,
	"pasive": true,
	"full_scale": false,
}
var binocular = {
	"name": "binocular",
	"friendly_name": "Binoculares",
	"description": "Perspectiva. Presiona 'H' para acceder.",
	"has_action": false,
	"pasive": true,
	"full_scale": false,
}
var none = {
	"name": "none",
	"friendly_name": "Nada",
	"description": "...",
	"has_action": false,
	"pasive": true,
	"full_scale": false,
}

var gunz_objs_prob = []
var gunz_equiped = []
var slots_stock = [0, 0]
var gunz_index = 0
var main_camera = null
var targets : Array = []
var GAMEOVER = false
var shaker_obj = null
var GizmoWatcher = null
var exit_door = null
var prisoner_counter = 0
var prisoner_total = 0
var bounce_amount = 0.3
var map_obj = null
var first_time = true
var Fader = null
var TerminalNumber = -1
var Gold = 0
var CurrentLevel = 0
var GoldDonation = 0
var ARTIFACT_PER_LEVEL = [false, false, false, false, false]
var UNLOCKS_PER_LEVEL = [null, map, double_jump, radar, invisibility, binocular, resurrect]
var GOLD_PER_LEVEL = [0, 10, 25, 50, 125, 200, 220]
var perks_equiped = [null, null, null, null, null, null, null]

var LASERS = true
var GHOSTS = true
var WATERFALLS = true
var FIREBALLS = true
var global_camera = null
var artifactPicked = false

enum TerminalsEnum {
	EYE = 0,
	LEAF = 1,
	TOMB = 2,
	MERMAID = 3,
	SALAMANDER = 4,
	SERAPH = 5,
}

var Terminals = [
	{
		"name": "El Ojo       ",
		"description" : "El Ojo     ",
		"status": true,
		"prisoners": 0,
		"variable" : {}
	},
	{
		"name": "La Hoja      ",
		"description" : "La Hoja    ",
		"status": true,
		"prisoners": 5,
		"variable" : {"LASERS": false}
	},
	{
		"name": "La Tumba     ",
		"description" : "La Tumba   ",
		"status": false,
		"prisoners": 5,
		"variable" : {"GHOSTS": false}
	},
	{
		"name": "La Sirena    ",
		"description" : "La Sirena     ",
		"status": false,
		"prisoners": 7,
		"variable" : {"WATERFALLS": false}
	},
	{
		"name": "La Salamandra",
		"description" : "La Salamandra",
		"status": false,
		"prisoners": 7,
		"variable" : {"FIREBALLS": false}
	},
	{
		"name": "El Serafin   ",
		"description" : "El Serafin   ",
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
	TITLE,
}

var CurrentState : GameStates = GameStates.TITLE
var FirstState : GameStates = GameStates.HOME

func scene_next(terminal_number = -1, boss = false):
	BOSS_ROOM = boss
	Global.TerminalNumber = terminal_number
	if Global.CurrentState == Global.GameStates.TITLE:
		Global.CurrentState = FirstState
	elif Global.CurrentState == Global.GameStates.HOME:
		Global.CurrentState = Global.GameStates.OUTSIDE
	elif Global.CurrentState == Global.GameStates.OUTSIDE:
		Global.CurrentState = Global.GameStates.FALLING
	elif Global.CurrentState == Global.GameStates.FALLING:
		Global.CurrentState = Global.GameStates.OVERWORLD
	elif Global.CurrentState == Global.GameStates.OVERWORLD or BOSS_ROOM:
		Global.LevelCurrentTerminalNumber = terminal_number
		Global.CurrentState = Global.GameStates.RANDOMLEVEL
	elif Global.CurrentState == Global.GameStates.RANDOMLEVEL:
		Global.CurrentState = Global.GameStates.OVERWORLD

	Global.Fader.fade_in()
	get_tree().reload_current_scene()

func remove_item():
	Global.slots_stock[Global.gunz_index] -= 1
	Global.GizmoWatcher.setHUD()
	
func find_my_item(itm):
	for p in Global.perks_equiped:
		if p and p.name == itm:
			return true
			
	return false

func donate(qty):
	if Global.Gold < qty or qty == 0:
		return null
	else:
		Global.GoldDonation += qty
		Global.Gold -= qty
		var result = levelup()
		save_game()
		Global.GizmoWatcher.setHUD(true)
		return result
		
func levelup():
	var new_level = 0
	for l in range(Global.GOLD_PER_LEVEL.size()):
		if Global.CurrentLevel < l:
			if Global.GoldDonation >= Global.GOLD_PER_LEVEL[l]:
				new_level += 1
			else:
				break
			
	if new_level >= Global.CurrentLevel:
		var perks_equiped_prev = [] + Global.perks_equiped
		Global.CurrentLevel = new_level
		set_current_perks()
		return perks_equiped_prev
	else:
		return Global.perks_equiped
	
func set_current_perks():
	for i in range(Global.CurrentLevel + 1):
		Global.perks_equiped[i] = Global.UNLOCKS_PER_LEVEL[i]

func buy_item(item, qty):
	if Global.Gold < qty or qty == 0:
		return false
	else:
		var itm = null
		if item == "BOMB":
			itm = bomb
		elif item == "SMOKE":
			itm = smoke_bomb
		elif item == "CLONE":
			itm = clone
		elif item == "SPRING":
			itm = spring
		elif item == "PLANT":
			itm = plant
		elif item == "MUFFIN":
			itm = muffin
			
		if itm:
			Global.Gold -= qty
			get_item(itm, qty)
			save_game()
			return true

func get_item(current_item, qty = 1):
	var found = false
	if current_item.name == "coin":
		Global.Gold += qty
		save_game()
	else:
		for i in range(Global.gunz_equiped.size()): #Try to add stock
			if Global.gunz_equiped[i].name == current_item.name:
				found = true
				slots_stock[i] += qty
				break;
				
		if !found:
			for i in range(Global.gunz_equiped.size()):  #Try to find empty slot 
				if Global.gunz_equiped[i].name == "none":
					Global.gunz_equiped[i] = current_item
					found = true
					slots_stock[i] = qty
					break;
					
		if !found: #If previus fails, override item to current selected
			Global.gunz_equiped[Global.gunz_index] = current_item
			slots_stock[Global.gunz_index] = 1
			
	var coin_o = (current_item.name == "coin")
	Global.GizmoWatcher.setHUD(coin_o)
	
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
	
func erase_game():
	DirAccess.remove_absolute("user://savegame.save")
	
func save_game():
	if Global.CurrentState != Global.GameStates.TITLE:
		var saved_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
		saved_game.store_var(Global.CurrentState)
		saved_game.store_var(Global.first_time)
		saved_game.store_var(Global.LASERS) #LEAF
		saved_game.store_var(Global.GHOSTS) #TOMB
		saved_game.store_var(Global.WATERFALLS) #MERMAID
		saved_game.store_var(Global.FIREBALLS) #DRAGON
		saved_game.store_var(Global.retro_game_high_score)
		saved_game.store_var(Global.Gold)
		saved_game.store_var(Global.CurrentLevel)
		saved_game.store_var(Global.GoldDonation)
		saved_game.store_var(Global.ARTIFACT_PER_LEVEL)
		saved_game.store_var(Global.FirstDeath)
		saved_game.close()
	
func load_game():
	var f_exists = FileAccess.file_exists("user://savegame.save")
	if f_exists:
		var saved_game = FileAccess.open("user://savegame.save", FileAccess.READ)
		if saved_game:
			var cur_state = saved_game.get_var()
			var f_time = saved_game.get_var()
			var lasers = saved_game.get_var()
			var ghosts = saved_game.get_var()
			var waterfalls = saved_game.get_var()
			var fireballs = saved_game.get_var()
			var high_score = saved_game.get_var()
			var gold = saved_game.get_var()
			var curr_level = saved_game.get_var()
			var g_donation = saved_game.get_var()
			var a_per_level = saved_game.get_var()
			var first_death = saved_game.get_var()
			
			if cur_state != null:
				Global.FirstState = cur_state
				if Global.FirstState == Global.GameStates.RANDOMLEVEL:
					#No se puede guardar en un randomlevel
					Global.FirstState = Global.GameStates.OVERWORLD
				
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
				if gold != null:
					Global.Gold = gold
				if curr_level != null:
					Global.CurrentLevel = curr_level
				if g_donation != null:
					Global.GoldDonation = g_donation
				if a_per_level != null:
					Global.ARTIFACT_PER_LEVEL = a_per_level
				if first_death != null:
					Global.FirstDeath = first_death

func _ready():
	load_sfx()
	load_game()
	set_current_perks()
	init()
	
func load_sfx():
	MainTheme = load("res://music/main_theme.mp3")
	MainThemeShort = load("res://music/main_theme_short.mp3")
	BossTheme = load("res://music/boss_theme.mp3")
	CaveAmbienceSFX = load("res://sfx/cave_ambience.mp3")
	HouseAmbienceSFX = load("res://sfx/house_ambience.mp3")
	ExteriorAmbienceSFX = load("res://sfx/exterior_ambience.mp3")
	FallingAmbienceSFX = load("res://sfx/falling_ambience.wav") #TODO: reemplazar
	
	PressStartSFX = load("res://sfx/press_start.wav")
	InteractSFX = null
	TelephoneRingSFX = load("res://sfx/telephone_ring.wav")
	TelephoneUpSFX = load("res://sfx/telephone_hang.wav")
	TelevisionOnSFX = load("res://sfx/television.wav")
	CryingSFX = null
	DialogSFX = load("res://sfx/dialog_snd.wav")
	JumpSFX = load("res://sfx/jump_snd.wav")
	WalkSFX = load("res://sfx/walk_snd.wav")
	FallSFX = load("res://sfx/player_fall_sound.wav")
	BigFallSFX = load("res://sfx/player_big_fall.wav")
	Boss1JumpSFX = null
	EnemyJumpSFX = null
	ClimbSFX = null
	BOSS1RoarSFX = null
	EnemyEatingSFX = null
	EnemyKillingSFX = null
	EnemyEaterAlertedSFX = null
	SpringSFX = null
	TerminalONSFX = null
	TerminalPrintSFX = null
	TerminalLevelUPSFX = null
	ChestOpenSFX = null
	PlantSFX = load("res://sfx/plants1.wav")
	Plant2SFX = load("res://sfx/plants2.wav")
	FallInWellSFX = load("res://sfx/fall_in_well.wav")
	ChainsSFX = null
	BombSFX = null
	BombTicSFX = null
	SmokeBombSFX = null
	PlantGrowSFX = null
	CloneSFX = null
	TeleportSFX = null
	MuffinSFX = null
	CoinSFX = null
	MapSFX = null
	RadarSFX = null
	ResurrectSFX = null
	BinocularSFX = null
	
func init():
	gunz_equiped = []
	gunz_index = 0
	main_camera = null
	targets = []
	GAMEOVER = false
	prisoner_counter = 0
	prisoner_total = 0
	map_obj = null
	var gunz_objs = []
	
	gunz_objs.append(clone)
	gunz_objs.append(teleport)
	gunz_objs.append(coin)
	gunz_objs.append(muffin)
	gunz_objs.append(bomb)
	gunz_objs.append(spring)
	gunz_objs.append(plant)
	gunz_objs.append(smoke_bomb)
	
	gunz_objs_prob = [] + gunz_objs
	for i in range(5):
		gunz_objs_prob.append(muffin)
		gunz_objs_prob.append(bomb)
		gunz_objs_prob.append(smoke_bomb)
		gunz_objs_prob.append(coin)
		gunz_objs_prob.append(coin)
		gunz_objs_prob.append(coin)
	
	gunz_equiped = [none, none]
	
	#DEBUG
	#slots_stock = [2, 0]
	#gunz_equiped[0] = plant
	
	randomize()
	
func reset_gunz():
	gunz_equiped = [none, none]
	
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
	if _audio_stream_player and is_instance_valid(_audio_stream_player):
		_audio_stream_player.queue_free()
