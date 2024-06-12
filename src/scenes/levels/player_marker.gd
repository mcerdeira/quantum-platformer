extends Marker2D
var player_clone = load("res://scenes/player.tscn")
var done = false
var nope = false
@export var gravityon = true
@export var enablecamera = true  
@export var first_time_based = false
@export var createme_on_firsttime = false
@export var cameralimits_on = true

func _ready():
	visible = false

func _process(delta):
	if !done:
		if !nope:
			if first_time_based:
				if createme_on_firsttime and !Global.first_time:
					queue_free()
					return
				
				if !createme_on_firsttime and Global.first_time:
					Global.first_time = false
					queue_free()
					return
			
			var Main = get_node("/root/Main")
			var pclone = player_clone.instantiate()
			pclone.global_position = global_position
			pclone.cameralimits_on = cameralimits_on
			if !cameralimits_on:
				pclone.center_camera()
				
			pclone.gravityon = gravityon
			if !enablecamera:
				pclone.enable_camera(false)
			Main.add_child(pclone)
			done = true
		queue_free()
