extends Marker2D
var post_o = load("res://scenes/post.tscn")
var player_clone = load("res://scenes/prisoner.tscn")
var done = false
var tomb = load("res://scenes/Tomb.tscn")
var faucet = load("res://scenes/Faucet.tscn")
var dead = false
@export var fixed = false

func _ready():
	add_to_group("prisoner_markers")
	visible = false
	done = fixed
	
func kill():
	dead = true
	queue_free()

func _process(_delta):
	if done:
		var Main = get_node("/root/Main")
		var post = null
		if Global.TerminalNumber == Global.TerminalsEnum.TOMB:
			post = tomb.instantiate()
			post.global_position = Vector2(global_position.x, global_position.y + 16)
			Main.add_child(post)
		elif Global.TerminalNumber == Global.TerminalsEnum.LEAF:
			post = post_o.instantiate()
			post.global_position = Vector2(global_position.x, global_position.y - 16)
			Main.add_child(post)
			
			var pclone = player_clone.instantiate()
			pclone.global_position = global_position
			Main.add_child(pclone)
			
		elif Global.TerminalNumber == Global.TerminalsEnum.MERMAID:
			post = faucet.instantiate()
			post.global_position = Vector2(global_position.x, global_position.y + 16)
			Main.add_child(post)
		elif Global.TerminalNumber == Global.TerminalsEnum.SALAMANDER:
			pass

		Global.prisoner_counter += 1
		Global.prisoner_total += 1
			
		done = false
		queue_free()
