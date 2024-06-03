extends Marker2D
var enemy = load("res://scenes/enemy.tscn")
var enemy_walker = load("res://scenes/enemy_walker.tscn")
var enemy_walker_walls = load("res://scenes/enemy_walker_walls.tscn")
var enemy_bullet = load("res://scenes/enemy_bullet.tscn")
@export var selected_enemy: String 

var done = false

func _ready():
	visible = false

func _process(delta):
	if !done:
		var eobj = selected_enemy
		if eobj or randi() % 2 == 0: 
			var Main = get_node("/root/Main")
			if !eobj:
				eobj = Global.pick_random([enemy, enemy_walker, enemy_bullet])
			else:
				eobj = enemy_walker_walls
			
			var pclone = eobj.instantiate()
			pclone.global_position = global_position
			Main.add_child(pclone)
			Global.emit(pclone.global_position, 10)
			
		done = true
		queue_free()

