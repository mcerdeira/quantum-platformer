extends Marker2D
var player_clone = load("res://scenes/player.tscn")
var prisoner_obj = preload("res://scenes/prisoner.tscn")
var done = false
@export var nope = false
@export var direction = "right"
@export var force_lookup = false
@export var gravityon = true
@export var enablecamera = true  
@export var first_time_based = false
@export var createme_on_firsttime = false
@export var cameralimits_on = true
@export var starting_valocity : Vector2 = Vector2.ZERO  
@export var CustomCamera : Camera2D = null
@export var locked_ctrls = false
var dialog_finalboss = false

func _ready():
	visible = false

func _process(_delta):
	if !done:
		if !nope:
			if first_time_based:
				if createme_on_firsttime and !Global.first_time:
					queue_free()
					return
				
				if !createme_on_firsttime and Global.first_time:
					Global.CameFromConsole = false
					Global.first_time = false
					Global.save_game()
					queue_free()
					return
					
			if !createme_on_firsttime:
				if Global.CameFromConsole:
					global_position = $"../player_marker_terminal".global_position
					Global.CameFromConsole = false
				if Global.CameFromShop:
					global_position = $"../player_marker_shop".global_position
					Global.CameFromShop = false
				if Global.FromLastBoss:
					Global.FromLastBoss = false
					global_position = $"../player_marker_lastboss".global_position
					dialog_finalboss = true
					
				if Global.FromPipe:
					global_position = $"../player_marker_pipe".global_position
					Global.FromPipe = false
					if Global.TOMB_STATUS and !Global.FromBonus:
						var pri = prisoner_obj.instantiate()
						pri.global_position = Vector2(global_position.x + 5, global_position.y - 16)
						get_parent().add_child(pri)
						pri.convert_into_npc()
						pri.delay_fall = 2.3
					
			var Main = get_node("/root/Main")
			var pclone = player_clone.instantiate()
			pclone.direction = direction
			pclone.force_lookup = force_lookup
			pclone.CustomCamera = CustomCamera
			pclone.global_position = global_position
			pclone.cameralimits_on = cameralimits_on
			pclone.locked_ctrls = locked_ctrls
			if starting_valocity != Vector2.ZERO:
				pclone.velocity = starting_valocity
				
			if dialog_finalboss:
				pclone.start_dialog_finalboss()
			
			if !cameralimits_on:
				pclone.center_camera()
				
			pclone.gravityon = gravityon
			if !enablecamera:
				pclone.enable_camera(false)
			Main.add_child(pclone)
			done = true
			if Global.CurrentState == Global.GameStates.PRE_ENDING:
				pclone.locked_ctrls = true
			
		queue_free()
