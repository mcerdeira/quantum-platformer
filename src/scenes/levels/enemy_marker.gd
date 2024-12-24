extends Marker2D
var enemy = load("res://scenes/enemy.tscn")
var enemy_walker = load("res://scenes/enemy_walker.tscn")
var enemy_walker_walls = load("res://scenes/enemy_walker_walls.tscn")
var enemy_bullet = load("res://scenes/enemy_bullet.tscn")
var enemy_slime = load("res://scenes/enemy_slime.tscn")
var enemy_flyer = load("res://scenes/enemy_flyer.tscn")
var enemy_bomber = load("res://scenes/enemy_bomber.tscn")

@export var selected_enemy: String 
@export var by_chance : bool = true

var done = false

func _ready():
	visible = false

func _process(_delta):
	if !done:
		var eobj
		var rand = 0
		if by_chance:
			rand = randi() % 2
		
		if selected_enemy or rand == 0: 
			var Main = get_node("/root/Main")
			if !selected_enemy:
				eobj = Global.pick_random([enemy, enemy_walker, enemy_flyer])
			else:
				if selected_enemy == "enemy_walker_walls":
					eobj = enemy_walker_walls
				elif selected_enemy == "enemy_walker":
					eobj = enemy_walker
				elif selected_enemy == "enemy_slime":
					eobj = enemy_slime
				elif selected_enemy == "enemy_bullet":
					eobj = enemy_bullet
				elif selected_enemy == "enemy":
					eobj = enemy
				elif selected_enemy == "enemy_flyer":
					eobj = enemy_flyer
				elif selected_enemy == "enemy_bomber":
					eobj = enemy_bomber
			
			var pclone = eobj.instantiate()
			pclone.global_position = global_position
			Main.add_child(pclone)
			
		done = true
		queue_free()

