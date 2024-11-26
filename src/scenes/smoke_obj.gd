extends Area2D
var ttl = 10
var smoke_obj = load("res://scenes/smokito.tscn")
var idx = 0
var done = false
var start_killing = false
var childs_ref = []
var vector_array: Array = [
	# Centro
		Vector2(0, 0),
		
		# Anillo 1
		Vector2(0, -32), Vector2(-32, 0), Vector2(32, 0), Vector2(0, 32),
		
		# Anillo 2
		Vector2(-64, -32), Vector2(-32, -32), Vector2(32, -32), Vector2(64, -32),
		Vector2(-64, 32), Vector2(-32, 32), Vector2(32, 32), Vector2(64, 32),
		
		# Anillo 3
		Vector2(-96, -64), Vector2(-64, -64), Vector2(-32, -64), Vector2(0, -64), 
		Vector2(32, -64), Vector2(64, -64), Vector2(96, -64),
		Vector2(-96, 64), Vector2(-64, 64), Vector2(-32, 64), Vector2(0, 64), 
		Vector2(32, 64), Vector2(64, 64), Vector2(96, 64),
		
		# Anillo 4
		Vector2(-128, -32), Vector2(-96, -32), Vector2(-64, -32), Vector2(-32, -32),
		Vector2(32, -32), Vector2(64, -32), Vector2(96, -32), Vector2(128, -32),
		Vector2(-128, 32), Vector2(-96, 32), Vector2(-64, 32), Vector2(-32, 32),
		Vector2(32, 32), Vector2(64, 32), Vector2(96, 32), Vector2(128, 32),
		
		# Anillo 5
		Vector2(-160, 0), Vector2(-128, 0), Vector2(-96, 0), Vector2(-64, 0),
		Vector2(-32, 0), Vector2(32, 0), Vector2(64, 0), Vector2(96, 0),
		Vector2(128, 0), Vector2(160, 0),
		
		# Anillo 6
		Vector2(-32, -128), Vector2(0, -128), Vector2(32, -128),
		Vector2(-64, -96), Vector2(-32, -96), Vector2(0, -96), Vector2(32, -96), Vector2(64, -96),
		Vector2(-64, 96), Vector2(-32, 96), Vector2(0, 96), Vector2(32, 96), Vector2(64, 96),
		Vector2(-32, 128), Vector2(0, 128), Vector2(32, 128),
		Vector2(0, 160),
		Vector2(0, -160)
]

func _ready():
	add_to_group("smoke_obj")
	
func _physics_process(delta):
	if start_killing:
		ttl -= 1 * delta
		if ttl <= 0:
			childs_ref.shuffle()
			var to_kill = childs_ref.pop_front()
			Global.emit(to_kill.global_position, 5)
			to_kill.queue_free()
			ttl = 0.3
			if childs_ref.size() <= 0:
				Global.emit(to_kill.global_position, 10)
				queue_free()
	else:
		if done:
			ttl -= 1 * delta
			if ttl <= 0:
				ttl = 0.5
				start_killing = true

func _on_timer_timeout():
	if idx < vector_array.size():
		create_smoke(vector_array[idx])
		idx += 1
	else:
		$Timer.stop()
		done = true

func create_smoke(pos):
	var smoke_o = smoke_obj.instantiate()
	smoke_o.position = pos
	add_child(smoke_o)
	Global.emit(global_position, 10)
	childs_ref.append(smoke_o)
