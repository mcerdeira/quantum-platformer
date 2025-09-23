extends Node
var AlreadySEEN = false
var FULLSCREEN = false
var SAVED_GAME = false
var particle = preload("res://scenes/particle2.tscn")
var CoinExploder = preload("res://scenes/Coinexploder.tscn")
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
var CameFromShop = false
var fade_finished = false
var BOSS_ROOM = false
var FirstDeath = true
var OverWorldFromGameOver = false
var TunnelTerminalNumber = false
var boss_bar = null
var BULLETS_MOVE = true
var gotoBOSS = false
var BOSS_DEAD = false
var total_water_particles = 0
var PauseStop = false
var BoatObj = null
var pauseobj = null
var FogObj = null

var SpecialLevelTheme = null
var WhooshSFX = null
var TombHitSFX = null
var TombBrokeSFX = null
var GhostBossHitSFX = null
var BeesSFX = null
var BeesAngrySFX = null
var ExplosionsndSXF = null
var ExplodeLoopSFX = null

var AltarSFX = null
var Item3DSFX = null
var ShotGunSFX = null
var RollingSFX = null
var PropSFX = null

var ButtonSFX = null
var RetroTheme = null
var MainTheme = null
var ShopTheme = null
var MainThemeShort = null
var BossTheme = null
var ThunderSFX = null
var FireAmbienceSFX = null
var RainAmbienceSFX = null
var CaveAmbienceSFX = null 
var TombAmbienceSFX = null
var HouseAmbienceSFX = null
var ExteriorAmbienceSFX = null
var FallingAmbienceSFX = null
var PressStartSFX = null
var FaucetSFX = null
var InteractSFX = null
var TelephoneRingSFX = null
var TelephoneUpSFX = null
var TelevisionOnSFX = null
var CryingSFX = null
var BrokenLampSFX = null
var LavaFallSFX = null
var DialogSFX = null
var JumpSFX = null
var WalkSFX = null
var BichoFeoSFX = null
var BichoFeo2SFX = null
var DoorOpensSFX = null
var ClimbSFX = null
var FallSFX = null
var PlayerSpikedSFX = null
var BigFallSFX = null
var EnemyJumpSFX = null
var Boss1JumpSFX = null
var BOSS1RoarSFX = null
var EnemyEatingSFX = null
var EnemyChewingSFX = null
var EnemyEaterAlertedSFX = null
var SpringSFX = null
var TerminalONSFX = null
var TerminalPrintSFX = null
var TerminalLevelUPSFX = null
var TerminalClickSFX = null
var ChestOpenSFX = null
var PlantSFX = null
var Plant2SFX = null
var Chains1SFX = null
var Chains2SFX = null
var FallInWellSFX = null
var BombSFX = null
var BombTicSFX = null
var SmokeBombSFX = null
var PlantGrowSFX = null
var CloneSFX = null
var EnemySnoreSFX = null
var TeleportSFX = null
var PlayerBleedSFX = null
var GizmoDropSFX = null
var GizmoLaunchSFX = null
var CoinSFX = null
var MapSFX = null
var RadarSFX = null
var ResurrectSFX = null
var BinocularSFX = null
var WaterDropSFX = null
var PrisonerReleasedSFX = null
var ExplodeRetroSFX = null
var BigExplodeRetroSFX = null
var PlayerHurtSFX = null
var PauseSFX = null
var GhostBossLaughSFX = null
var BossThemeGhost = null
var GurgleSFX = null
var SpitSFX = null
var Gusanote1SFX = null
var Gusanote2SFX = null
var Gusanote3SFX = null
var CombinationOKSFX = null
var BoatUnlockedSFX = null
var PersecutionBossSFX = null
var BoatUnlocked = false
var combinatoryOK = false

var video_tutorials = []

var bomb_tutorial = null
var clone_tutorial = null
var muffin_tutorial = null
var plant_tutorial = null
var smoke_tutorial = null
var spring_tutorial = null
var teleport_tutorial = null

var first_time_smoke = true
var first_time_plant = true
var first_time_clone = true
var first_time_teleport = true
var first_time_muffin = true
var first_time_bomb = true
var first_time_spring = true
var video_tutorial = null
var gamepad = 0
var RADARKEY = ["'R'", "'Y'"]
var MAPKEY = ["'M'", "'RT'"]
var BINOCULARKEY = ["'H'", "'LT'"]

var Aracnofobia = false
var ReducirDestellos = false
var MusicVolume = 100
var SfxVolume = 100
var DEATHS = 0
var save_icon = null

#CHEST ITEMS 

var smoke_bomb = {
	"name": "smoke",
	"dialog": "PUFF!!",
	"friendly_name": "Humo",
	"description": "Los enemigos no te veran.",
	"tutorial": "Con esta bomba vas a pasar inadvertido, ya que los enemigos no te verán.",
	"tutorial_idx": 4,
	"has_action": true,
	"pasive": false,
	"full_scale": true,
	"stock": 0,
}
var plant = {
	"name": "plant",
	"dialog": "¡VAMOS!",
	"friendly_name": "Plantita",
	"description": "¡Crece y crece!",
	"tutorial": "Lanza una pequeña planta que se extiende verticalmete funcionando como una escalera.",
	"tutorial_idx": 3,
	"has_action": true,
	"pasive": false,
	"full_scale": true,
	"stock": 0,
}
var clone = {
	"name": "clone",
	"dialog": "¡EPA!",
	"friendly_name": "Clonador",
	"description": "Genera una copia tuya.",
	"tutorial": "Genera copias de vos mismo, pero cuidado: ¡no abusar!.",
	"tutorial_idx": 1,
	"has_action": true,
	"pasive": false,
	"full_scale": false,
	"stock": 0,
}
var teleport = {
	"name": "teleport",
	"dialog": "¡NOS VIMO!",
	"friendly_name": "Teletransportador",
	"description": "Viaje instantaneo en el espacio.",
	"tutorial": "Muy util teletransportación instantánea.",
	"tutorial_idx": 6,
	"has_action": true,
	"pasive": false,
	"full_scale": false,
	"stock": 0,
}

var spikeball = {
	"name": "spikeball",
	"dialog": "¡EPA!",
	"friendly_name": "Bola Pinchuda",
	"description": "¡Ouch!",
	"tutorial": "",
	"tutorial_idx": -1,
	"has_action": false,
	"pasive": false,
	"full_scale": true,
	"stock": 0,
}

var muffin = {
	"name": "muffin",
	"dialog": "¡RICO!",
	"friendly_name": "Golosina",
	"description": "¡Que rico!",
	"tutorial": "Si algun enemigo come esta golosina, se va a quedar dormido.",
	"tutorial_idx": 2,
	"has_action": false,
	"pasive": false,
	"full_scale": false,
	"stock": 0,
}
var bomb = {
	"name": "bomb",
	"dialog": "¡PUMMM!!",
	"friendly_name": "Bomba",
	"description": "¡Bum!",
	"tutorial": "Al explotar knockea a los enemigos... pero no los mata.",
	"tutorial_idx": 0,
	"has_action": true,
	"pasive": false,
	"full_scale": true,
	"stock": 0,
}
var coin = {
	"name": "coin",
	"dialog": "¡EPA!",
	"friendly_name": "Moneda",
	"description": "Gruta-Monedas",
	"tutorial": "",
	"tutorial_idx": -1,
	"has_action": false,
	"pasive": true,
	"full_scale": false,
}
var spring = {
	"name": "spring",
	"dialog": "¡ESA!",
	"friendly_name": "Resorte",
	"description": "¡Toing! ¡Toing!",
	"tutorial": "Lanza este item para usarlo como catapulta para saltar mucho mas alto.",
	"tutorial_idx": 5,
	"has_action": false,
	"pasive": false,
	"full_scale": true,
	"stock": 0,
}
#PASIVE ITEMS 
var radar = {
	"name": "radar",
	"dialog": "EPA!",
	"friendly_name": "Radar",
	"description": "Apunta a la salida. Presiona {RADARKEY} para acceder.",
	"has_action": false,
	"pasive": true,
	"full_scale": false,
	"price": 250,
	"idx": 3,
}
var map = {
	"name": "map",
	"dialog": "EPA!",
	"friendly_name": "Mapa",
	"description": "Presiona {MAPKEY} para acceder.",
	"has_action": false,
	"pasive": true,
	"full_scale": false,
	"price": 10,
	"idx": 1,
}
var double_jump = {
	"name": "wings",
	"dialog": "EPA!",
	"friendly_name": "Alas",
	"description": "¡Volar! (casi)",
	"has_action": false,
	"pasive": true,
	"full_scale": false,
	"price": 250,
	"idx": 2,
}
var resurrect = {
	"name": "resurrect",
	"dialog": "EPA!",
	"friendly_name": "Resureccion",
	"description": "Un intento más.",
	"has_action": false,
	"pasive": true,
	"full_scale": false,
	"price": 1200,
	"idx": 6,
}
var invisibility = {
	"name": "invisibility",
	"dialog": "EPA!",
	"friendly_name": "Invisibilidad",
	"description": "Si te quedas quieto, no te veran.",
	"has_action": false,
	"pasive": true,
	"full_scale": false,
	"price": 900,
	"idx": 4,
}
var binocular = {
	"name": "binocular",
	"dialog": "EPA!",
	"friendly_name": "Binoculares",
	"description": "Perspectiva. Presiona {BINOCULARKEY} para acceder.",
	"has_action": false,
	"pasive": true,
	"full_scale": false,
	"price": 100,
	"idx": 5,
}
var none = {
	"name": "none",
	"dialog": "EPA!",
	"friendly_name": "Nada",
	"description": "...",
	"has_action": false,
	"pasive": true,
	"full_scale": false,
	"price": 0,
}

var gunz_objs = []
var gunz_objs_prob = []
var gunz_objs_prob_nocoin = []
var gunz_equiped_real = []
var gunz_equiped = []
var gunz_index_max = 0
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
var FromPipe = false
var FromBonus = false
var FromLastBoss = false

var LASERS = true
var GHOSTS = true
var WATERFALLS = true
var FIREBALLS = true
var global_camera = null
var BinocularFade = null

enum TerminalsEnum {
	EYE = 0,
	LEAF = 1,
	TOMB = 2,
	MERMAID = 3,
	SALAMANDER = 4,
	SERAPH = 5,
}

var LEAF_STATUS = true
var TOMB_STATUS = false
var MERMAID_STATUS = false
var SALAMANDER_STATUS = false
var SERAPH_STATUS = false

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
		"variable" : {"BOLAS_FUEGO": true}
	},
	{
		"name": "La Tumba     ",
		"description" : "La Tumba   ",
		"status": false,
		"prisoners": 4,
		"variable" : {"FANTASMAS": true}
	},
	{
		"name": "La Sirena    ",
		"description" : "La Sirena     ",
		"status": false,
		"prisoners": 7,
		"variable" : {"CASCADAS": true}
	},
	{
		"name": "La Salamandra",
		"description" : "La Salamandra",
		"status": false,
		"prisoners": 7,
		"variable" : {"LASERS": true}
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
	DEMO,#No se usa en el juego, es para grabar videos
	CHALLENGE,
	SHOP,
	OVERWORLD_ENDING,
	PRE_ENDING,
}

var CurrentState : GameStates = GameStates.TITLE
var FirstState : GameStates = GameStates.HOME

func scene_next(terminal_number = -1, boss = false, special = false, shop = false, from_boss = false):
	Global.gunz_index = 0
	Global.gunz_index_max = 0
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
		if shop:
			Global.CurrentState = Global.GameStates.SHOP
		
	elif Global.CurrentState == Global.GameStates.RANDOMLEVEL and special:
		Global.CurrentState = Global.GameStates.CHALLENGE
	elif Global.CurrentState == Global.GameStates.RANDOMLEVEL:
		if !from_boss:
			Global.reset_gunz()
		Global.restore_gunz()
		Global.CurrentState = Global.GameStates.OVERWORLD
		Global.TerminalNumber = -1
	elif Global.CurrentState == Global.GameStates.CHALLENGE:
		Global.CurrentState = Global.GameStates.OVERWORLD
	elif Global.CurrentState == Global.GameStates.SHOP:
		Global.CameFromShop = true
		Global.CurrentState = Global.GameStates.OVERWORLD

	Global.Fader.fade_in()
	get_tree().reload_current_scene()

func remove_item():
	Global.gunz_equiped[0].stock -= 1
	Global.GizmoWatcher.setHUD()
	
func find_my_item(itm):
	for p in Global.perks_equiped:
		if p and p.name == itm:
			return true
			
	return false
	
func find_item(find_name):
	for itm in UNLOCKS_PER_LEVEL:
		if itm != null:
			if itm.name == find_name:
				return itm
						
func buy_item_perk(item, qty, idx):
	if Global.Gold < qty or qty == 0:
		return false
	else:
		Global.perks_equiped[idx] = Global.UNLOCKS_PER_LEVEL[idx]
		Global.player_obj.calc_perks()
		Global.GizmoWatcher.setHUD(true)
		save_game()
		return true

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
		elif item == "TELEPORT":
			itm = teleport
			
		if itm:
			Global.Gold -= qty
			get_item(itm, qty)
			save_game()
			return true

func drop_coins(_global_position, supercoin = false):
	Global.play_sound(Global.CoinSFX, {}, _global_position)
	var counts = [5, 10, 7]
	
	var coins = Global.pick_random(counts)
	if supercoin:
		coins *= Global.pick_random([2, 3, 4])
	
	for i in range(coins):
		var p = CoinExploder.instantiate()
		p.global_position = _global_position
		add_child(p)

func get_item(current_item, qty = 1):
	var found = false
	if current_item.name == "coin":
		Global.Gold += qty
		save_game()
	else:
		for i in range(Global.gunz_equiped.size()): #Try to add stock
			if Global.gunz_equiped[i].name == current_item.name:
				found = true
				Global.gunz_equiped[i].stock += qty
				Global.gunz_index_max = i
				break;
				
		if !found:
			Global.gunz_equiped.append(none)
			for i in range(Global.gunz_equiped.size()):  #Try to find empty slot 
				if Global.gunz_equiped[i].name == "none":
					Global.gunz_equiped[i] = current_item
					found = true
					Global.gunz_equiped[i].stock = qty
					Global.gunz_index_max = i
					break;
			
	var coin_o = (current_item.name == "coin")
	Global.GizmoWatcher.setHUD(coin_o)
	
func emit(_global_position, count, particle_obj = null, size = 1):
	var part = particle
	if particle_obj:
		part = particle_obj
	
	for i in range(count):
		var p = part.instantiate()
		p.global_position = _global_position
		p.size = size
		add_child(p)
		
func flyaway(direction, jump_speed):
	var velocity = Vector2()
	velocity.x = direction.x * 65.0
	velocity.y = jump_speed * 1.4
	return velocity
	
func erase_game():
	DirAccess.remove_absolute("user://savegame.save")
	
func save_options():
	var saved_options = FileAccess.open("user://options.save", FileAccess.WRITE)
	saved_options.store_var(Global.FULLSCREEN)
	saved_options.store_var(Global.Aracnofobia)
	saved_options.store_var(Global.ReducirDestellos)
	saved_options.store_var(Global.MusicVolume)
	saved_options.store_var(Global.SfxVolume)
	saved_options.close()
	
func load_options():
	var f_exists = FileAccess.file_exists("user://options.save")
	if f_exists:
		var saved_options = FileAccess.open("user://options.save", FileAccess.READ)
		if saved_options:
			var fullscreen = saved_options.get_var()
			Global.FULLSCREEN = fullscreen
			apply_fullscreen()
			
			var aracno = saved_options.get_var()
			Global.Aracnofobia = aracno
			
			var deste = saved_options.get_var()
			Global.ReducirDestellos = deste
			
			var musicv = saved_options.get_var()
			Global.MusicVolume = musicv
			apply_music_volume()
			
			var sfxv = saved_options.get_var()
			Global.SfxVolume = sfxv
			apply_sfx_volume()
				
	
func apply_sfx_volume():
	var SFX = -4.8
	var music_bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(music_bus_index, log_volume(Global.SfxVolume, SFX))
	
func apply_music_volume():
	var MUSIC = -8.0
	var music_bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_bus_index, log_volume(Global.MusicVolume, MUSIC))
	
func log_volume(value, base_volume_db):
	var percent = value / 100.0
	var linear_scale = max(0.0001, percent)
	var db_scale = linear_to_db(linear_scale)
	var new_db = base_volume_db + db_scale
	return new_db
	
func apply_fullscreen():
	if Global.FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
func save_game():
	if Global.CurrentState != Global.GameStates.TITLE:
		if Global.save_icon and is_instance_valid(Global.save_icon):
			Global.save_icon.show_me()
			
		var saved_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
		saved_game.store_var(Global.CurrentState)
		saved_game.store_var(Global.first_time)
		saved_game.store_var(Global.FIREBALLS) #LEAF
		saved_game.store_var(Global.GHOSTS) #TOMB
		saved_game.store_var(Global.WATERFALLS) #MERMAID
		saved_game.store_var(Global.LASERS) #DRAGON
		saved_game.store_var(Global.retro_game_high_score)
		saved_game.store_var(Global.Gold)
		saved_game.store_var(Global.perks_equiped)
		saved_game.store_var(Global.GoldDonation)
		saved_game.store_var(Global.ARTIFACT_PER_LEVEL)
		saved_game.store_var(Global.FirstDeath)
		
		saved_game.store_var(Global.LEAF_STATUS)
		saved_game.store_var(Global.TOMB_STATUS)
		saved_game.store_var(Global.MERMAID_STATUS)
		saved_game.store_var(Global.SALAMANDER_STATUS)
		saved_game.store_var(Global.SERAPH_STATUS)
		
		saved_game.store_var(Global.first_time_smoke)
		saved_game.store_var(Global.first_time_plant)
		saved_game.store_var(Global.first_time_clone)
		saved_game.store_var(Global.first_time_teleport)
		saved_game.store_var(Global.first_time_muffin)
		saved_game.store_var(Global.first_time_bomb)
		saved_game.store_var(Global.first_time_spring)
		saved_game.store_var(Global.gunz_equiped_real)
		saved_game.store_var(Global.gotoBOSS)
		saved_game.store_var(Global.BoatUnlocked)
		saved_game.store_var(Global.AlreadySEEN)
		saved_game.store_var(Global.DEATHS)
		saved_game.close()
	
func load_game():
	var f_exists = FileAccess.file_exists("user://savegame.save")
	if f_exists:
		var saved_game = FileAccess.open("user://savegame.save", FileAccess.READ)
		if saved_game:
			var cur_state = saved_game.get_var()
			var f_time = saved_game.get_var()
			var fireballs = saved_game.get_var()
			var ghosts = saved_game.get_var()
			var waterfalls = saved_game.get_var()
			var lasers = saved_game.get_var()
			var high_score = saved_game.get_var()
			var gold = saved_game.get_var()
			var perks_equiped = saved_game.get_var()
			var g_donation = saved_game.get_var()
			var a_per_level = saved_game.get_var()
			var first_death = saved_game.get_var()
			
			var leaf_status = saved_game.get_var()
			var tomb_status = saved_game.get_var()
			var mermaid_status = saved_game.get_var()
			var salamander_status = saved_game.get_var()
			var seraph_status = saved_game.get_var()
			
			var _first_time_smoke = saved_game.get_var()
			var _first_time_plant = saved_game.get_var()
			var _first_time_clone = saved_game.get_var()
			var _first_time_teleport = saved_game.get_var()
			var _first_time_muffin = saved_game.get_var()
			var _first_time_bomb = saved_game.get_var()
			var _first_time_spring = saved_game.get_var()
			var _gunz_equiped_real = saved_game.get_var()
			var _gotoBOSS = saved_game.get_var()
			var _BoatUnlocked = saved_game.get_var()
			var _AlreadySEEN = saved_game.get_var()
			var _deaths = saved_game.get_var()
			
			if cur_state != null:
				Global.FirstState = cur_state
				if Global.FirstState == Global.GameStates.RANDOMLEVEL or Global.FirstState == Global.GameStates.SHOP or Global.FirstState == Global.GameStates.CHALLENGE:
					#No se puede guardar en un nivel random, o el shop o el challenge
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
				if perks_equiped != null:
					Global.perks_equiped = perks_equiped
				if g_donation != null:
					Global.GoldDonation = g_donation
				if a_per_level != null:
					Global.ARTIFACT_PER_LEVEL = a_per_level
				if first_death != null:
					Global.FirstDeath = first_death
					
				if leaf_status != null:
					Global.LEAF_STATUS = leaf_status
				if tomb_status != null:
					Global.TOMB_STATUS = tomb_status
				if mermaid_status != null:
					Global.MERMAID_STATUS = mermaid_status
				if salamander_status != null:
					Global.SALAMANDER_STATUS = salamander_status
				if seraph_status != null:
					Global.SERAPH_STATUS = seraph_status
					
				if _first_time_smoke != null:
					Global.first_time_smoke = _first_time_smoke
				if _first_time_plant != null:
					Global.first_time_plant = _first_time_plant
				if _first_time_clone != null:
					Global.first_time_clone = _first_time_clone
				if _first_time_teleport != null:
					Global.first_time_teleport = _first_time_teleport
				if _first_time_muffin != null:
					Global.first_time_muffin = _first_time_muffin
				if _first_time_bomb != null:
					Global.first_time_bomb = _first_time_bomb
				if _first_time_spring != null:
					Global.first_time_spring = _first_time_spring
				if _gunz_equiped_real != null:
					Global.gunz_equiped_real = _gunz_equiped_real
				if _gotoBOSS != null:
					Global.gotoBOSS = _gotoBOSS
				if _BoatUnlocked != null:
					Global.BoatUnlocked = _BoatUnlocked
				if _AlreadySEEN != null:
					Global.AlreadySEEN = _AlreadySEEN
				if _deaths != null:
					Global.DEATHS = _deaths
				
	else:
		Global.FirstState =  GameStates.HOME
		Global.first_time = true
		Global.retro_game_high_score = 9000
		Global.LASERS = true
		Global.GHOSTS = true
		Global.WATERFALLS = true
		Global.FIREBALLS = true
		Global.Gold = 0
		Global.perks_equiped = [null, null, null, null, null, null, null]
		Global.GoldDonation = 0
		Global.ARTIFACT_PER_LEVEL = [false, false, false, false, false]
		Global.FirstDeath = true
		Global.LEAF_STATUS = true
		Global.TOMB_STATUS = false
		Global.MERMAID_STATUS = false
		Global.SALAMANDER_STATUS = false
		Global.SERAPH_STATUS = false
		Global.first_time_smoke = true
		Global.first_time_plant = true
		Global.first_time_clone = true
		Global.first_time_teleport = true
		Global.first_time_muffin = true
		Global.first_time_bomb = true
		Global.first_time_spring = true
		Global.gunz_equiped_real = []
		Global.gotoBOSS = false
		Global.BoatUnlocked = false
		Global.AlreadySEEN = false
		Global.DEATHS = 0
		
	sync_terminals()
	
func sync_terminals():
	for t in Global.Terminals:
		if t.name.strip_edges() == "La Hoja":
			t.status = Global.LEAF_STATUS
		elif t.name.strip_edges() == "La Tumba":
			t.status = Global.TOMB_STATUS
		elif t.name.strip_edges() == "La Sirena":
			t.status = Global.MERMAID_STATUS
		elif t.name.strip_edges() == "La Salamandra":
			t.status = Global.SALAMANDER_STATUS
		elif t.name.strip_edges() == "El Serafin":
			t.status = Global.SERAPH_STATUS
			
func sync_this_terminal(terminal_number):
	var t = Global.Terminals[terminal_number]
	if t.name.strip_edges() == "La Hoja":
		if t.status != Global.LEAF_STATUS:
			t.status = Global.LEAF_STATUS
			return true
	elif t.name.strip_edges() == "La Tumba":
		if t.status != Global.TOMB_STATUS:
			t.status = Global.TOMB_STATUS
			return true
	elif t.name.strip_edges() == "La Sirena":
		if t.status != Global.MERMAID_STATUS:
			t.status = Global.MERMAID_STATUS
			return true
	elif t.name.strip_edges() == "La Salamandra":
		if t.status != Global.SALAMANDER_STATUS:
			t.status = Global.SALAMANDER_STATUS
			return true
	elif t.name.strip_edges() == "El Serafin":
		if t.status != Global.SERAPH_STATUS:
			t.status = Global.SERAPH_STATUS
			return true
					
func init_game():
	load_sfx()
	load_game()
	load_options()
	#set_current_perks()
	init()

func _ready():
	init_game()
	
func load_sfx():
	ShopTheme = load("res://music/ShopTheme.mp3")
	SpecialLevelTheme = load("res://music/SpecialLevel.wav")
	MainTheme = load("res://music/main_theme.mp3")
	MainThemeShort = load("res://music/main_theme_short.mp3")
	BossTheme = load("res://music/boss_theme.mp3")
	BossThemeGhost = load("res://music/BossGhostLoop.wav")
	CaveAmbienceSFX = load("res://sfx/cave_ambience.mp3")
	TombAmbienceSFX = load("res://sfx/tomb_ambience.mp3")
	HouseAmbienceSFX = load("res://sfx/house_ambience.mp3")
	RainAmbienceSFX = load("res://sfx/rain_ambience.wav")
	ExteriorAmbienceSFX = load("res://sfx/exterior_ambience.mp3")
	FireAmbienceSFX = load("res://sfx/FireAmbienceSFX.wav")
	
	PressStartSFX = load("res://sfx/press_start.wav")
	InteractSFX = load("res://sfx/interact_snd.wav")
	TelephoneRingSFX = load("res://sfx/telephone_ring.wav")
	TelephoneUpSFX = load("res://sfx/telephone_hang.wav")
	TelevisionOnSFX = load("res://sfx/television.wav")
	DialogSFX = load("res://sfx/dialog_snd.wav")
	JumpSFX = load("res://sfx/jump_snd.wav")
	WalkSFX = load("res://sfx/walk_snd.wav")
	FallSFX = load("res://sfx/player_fall_sound.wav")
	BigFallSFX = load("res://sfx/player_big_fall.wav")
	TerminalClickSFX = load("res://sfx/click9.mp3")
	Boss1JumpSFX = load("res://sfx/jump.wav")
	EnemyJumpSFX = load("res://sfx/jump.wav")
	TerminalONSFX = load("res://sfx/boot.mp3") 
	PlantSFX = load("res://sfx/plants1.wav")
	Plant2SFX = load("res://sfx/plants2.wav")
	BOSS1RoarSFX = load("res://sfx/boss1_roar.wav")
	ChestOpenSFX = load("res://sfx/chest_open.mp3")
	TerminalPrintSFX = load("res://sfx/Dot Matrix Printer.wav")
	FallingAmbienceSFX = load("res://sfx/falling_ambience.wav")
	SpringSFX = load("res://sfx/spring.mp3")
	SmokeBombSFX = load("res://sfx/BombExplosionSfx.wav")
	BombSFX = load("res://sfx/BombExplosionSfx.wav")
	EnemySnoreSFX = load("res://sfx/snore.wav")
	EnemyEatingSFX = load("res://sfx/Deep Gulp Sound Effect.mp3")
	EnemyChewingSFX = load("res://sfx/chewing.wav")
	PlayerBleedSFX = load("res://sfx/bleed.wav")
	TeleportSFX = load("res://sfx/teleport_snd.wav")
	CloneSFX = load("res://sfx/teleport_snd.wav")
	Chains1SFX = load("res://sfx/chain1.wav")
	Chains2SFX = load("res://sfx/chain2.wav")
	MapSFX = load("res://sfx/map.wav")
	GizmoLaunchSFX = load("res://sfx/gizmo_launch.wav")
	GizmoDropSFX = load("res://sfx/gizmo_drop.wav")
	LavaFallSFX = load("res://sfx/lava_snd.wav")
	PlayerSpikedSFX = load("res://sfx/spiked.wav")
	FallInWellSFX = load("res://sfx/fall_in_well.wav")
	EnemyEaterAlertedSFX = load("res://sfx/enemy_alerted.wav")
	ResurrectSFX = load("res://sfx/resurrect_snd.wav")
	RadarSFX = load("res://sfx/radar.wav")
	BombTicSFX = load("res://sfx/bombtick.wav")
	ClimbSFX = load("res://sfx/climb_snd.mp3")
	BrokenLampSFX = load("res://sfx/broken_glass.wav")
	WaterDropSFX = load("res://sfx/water_drop.wav")
	CryingSFX = load("res://sfx/crying.wav")
	PlantGrowSFX = load("res://sfx/plant_gros.wav")
	CoinSFX = load("res://sfx/coins.wav")
	TerminalLevelUPSFX = load("res://sfx/level_up.wav")
	PrisonerReleasedSFX = load("res://sfx/prisoner_liberate.wav")
	BinocularSFX = load("res://sfx/binocular.wav")
	RetroTheme = load("res://music/retro_theme.mp3")
	BigExplodeRetroSFX = load("res://sfx/big_explode_retro.wav")
	ExplodeRetroSFX = load("res://sfx/explode_retro.wav")
	PlayerHurtSFX = load("res://sfx/player_hurt.wav")
	PauseSFX = load("res://sfx/pause_sfx.wav")
	ButtonSFX = load("res://sfx/button_sound.wav")
	DoorOpensSFX = load("res://sfx/door_opens.wav")
	BichoFeoSFX = load("res://sfx/BichoFeo.wav")
	BichoFeo2SFX = load("res://sfx/BichoFeo2.wav")
	GhostBossLaughSFX = load("res://sfx/ghost_boss_laugh.mp3")
	GurgleSFX = load("res://sfx/gurgle.wav")
	
	Gusanote1SFX = load("res://sfx/Gusanote1SFX.wav")
	Gusanote2SFX = load("res://sfx/Gusanote2SFX.wav")
	Gusanote3SFX = load("res://sfx/Gusanote3SFX.wav")
	
	WhooshSFX = load("res://sfx/Whoosh.wav")
	TombHitSFX = load("res://sfx/TombHit.wav")
	TombBrokeSFX = load("res://sfx/TombBroke.wav")
	GhostBossHitSFX = load("res://sfx/GhostBossHit.wav")
	ThunderSFX = load("res://sfx/thunder.wav") 
	
	BeesSFX = load("res://sfx/bees_sfx.wav")
	BeesAngrySFX = load("res://sfx/bees_angry.wav")
	ExplosionsndSXF = load("res://sprites/horu/audio/explosion_snd.wav")
	ExplodeLoopSFX = load("res://sfx/explode_loop.wav")
	FaucetSFX = load("res://sfx/faucet.wav")
	
	AltarSFX = load("res://sfx/AltarSfx.wav")
	Item3DSFX = load("res://sfx/Item3D.wav")
	ShotGunSFX = load("res://sfx/ShotGunSfx.wav")
	RollingSFX = load("res://sfx/rolling.wav")
	PropSFX = load("res://sfx/PropsSfx.wav")
	CombinationOKSFX = load("res://sfx/CombinationOK.wav")
	BoatUnlockedSFX = load("res://sfx/BoatUnlocked.wav")
	PersecutionBossSFX = load("res://sfx/boss_persecution.wav")
	SpitSFX = load("res://sfx/spit_sound.wav")

	bomb_tutorial = load("res://video/bomb_tutorial.ogv")
	clone_tutorial = load("res://video/clone_tutorial.ogv")
	muffin_tutorial = load("res://video/muffin_tutorial.ogv")
	plant_tutorial = load("res://video/plant_tutorial.ogv")
	smoke_tutorial = load("res://video/smoke_tutorial.ogv")
	spring_tutorial = load("res://video/spring_tutorial.ogv")
	teleport_tutorial = load("res://video/teleport_tutorial.ogv")
	
	video_tutorials = [bomb_tutorial, clone_tutorial, muffin_tutorial, plant_tutorial, smoke_tutorial, spring_tutorial, teleport_tutorial]
	
func init():
	gunz_equiped = []
	gunz_index_max = 0
	gunz_index = 0
	main_camera = null
	targets = []
	GAMEOVER = false
	prisoner_counter = 0
	prisoner_total = 0
	map_obj = null
	
	gunz_objs = []
	
	gunz_objs_prob_nocoin = []
		
	gunz_objs.append(clone)
	gunz_objs.append(teleport)
	gunz_objs.append(coin)
	gunz_objs.append(muffin)
	gunz_objs.append(bomb)
	gunz_objs.append(spring)
	gunz_objs.append(plant)
	gunz_objs.append(smoke_bomb)
	
	gunz_objs_prob = [] 
	
	add_with_weigth(gunz_objs_prob, 4, clone)
	add_with_weigth(gunz_objs_prob, 4, teleport)
	add_with_weigth(gunz_objs_prob, 5, coin)
	add_with_weigth(gunz_objs_prob, 5, muffin)
	add_with_weigth(gunz_objs_prob, 2, bomb)
	add_with_weigth(gunz_objs_prob, 4, spring)
	add_with_weigth(gunz_objs_prob, 4, plant)
	add_with_weigth(gunz_objs_prob, 4, smoke_bomb)
	
	add_with_weigth(gunz_objs_prob_nocoin, 4, clone)
	add_with_weigth(gunz_objs_prob_nocoin, 4, teleport)
	add_with_weigth(gunz_objs_prob_nocoin, 5, muffin)
	add_with_weigth(gunz_objs_prob_nocoin, 1, bomb)
	add_with_weigth(gunz_objs_prob_nocoin, 4, spring)
	add_with_weigth(gunz_objs_prob_nocoin, 4, plant)
	add_with_weigth(gunz_objs_prob_nocoin, 4, smoke_bomb)
	
	Global.restore_gunz()
	
	randomize()
	
func add_with_weigth(obj, qty, item):
	for i in range(qty):
		obj.append(item)
	
func restore_gunz():
	gunz_equiped = []
	for gun in gunz_equiped_real:
		if gun.name != "spikeball":
			gunz_equiped.append(gun)
	
func reset_gunz():
	var gunz_tmp = []
	for gun in gunz_equiped:
		if gun.name != "spikeball":
			gunz_tmp.append(gun)
	
	gunz_equiped = []
	if gunz_tmp.size() > 0:
		gunz_equiped_real = []
		for gun in gunz_tmp:
			gunz_equiped_real.append(gun)
	
func pick_random(container):
	if typeof(container) == TYPE_DICTIONARY:
		return container.values()[randi() % container.size() ]
	assert( typeof(container) in [
			TYPE_ARRAY, TYPE_PACKED_COLOR_ARRAY, TYPE_PACKED_INT32_ARRAY,
			TYPE_PACKED_BYTE_ARRAY, TYPE_PACKED_FLOAT32_ARRAY, TYPE_PACKED_STRING_ARRAY,
			TYPE_PACKED_VECTOR2_ARRAY, TYPE_PACKED_VECTOR3_ARRAY
			], "ERROR: pick_random" )
	return container[randi() % container.size()]
	
func is_ok_FX(global_position):
	if global_position and Global.player_obj and is_instance_valid(Global.player_obj):
		var width = Vector2(global_position.x, 0)
		var height = Vector2(0, global_position.y)
		var player_width = Vector2(Global.player_obj.global_position.x, 0)
		var player_height = Vector2(0, Global.player_obj.global_position.y)
		
		if player_width.distance_to(width) > 1152:
			return false
		if player_height.distance_to(height) > 640:
			return false
	
	return true

func play_sound(stream: AudioStream, options:= {}, _global_position = null) -> AudioStreamPlayer:
	if !is_ok_FX(_global_position):
		return
	
	var audio_stream_player = AudioStreamPlayer.new()
	audio_stream_player.process_mode = Node.PROCESS_MODE_ALWAYS

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
