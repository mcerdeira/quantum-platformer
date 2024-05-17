extends Marker2D
var player_clone = load("res://scenes/player.tscn")
var done = false
var nope = false

func _ready():
	visible = false

func _process(delta):
	if !done:
		if !nope:
			var Main = get_node("/root/Main")
			var pclone = player_clone.instantiate()
			pclone.global_position = global_position
			Main.add_child(pclone)
			Global.emit(pclone.global_position, 10)
			done = true
		queue_free()
