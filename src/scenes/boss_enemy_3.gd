extends CharacterBody2D
var waterdrop = preload("res://scenes/water_drp.tscn")
var watersplash = preload("res://scenes/Confeti.tscn")
var ttl_drop = 0.0
var moving = true
var x_direction = 0
var jumpspeed = 60
var speed: float = 200.0
var count_total = 2
var count = count_total
var TOTAL_LIFE = 8.0
var LIFE = TOTAL_LIFE
var first_time = true
var tail_ttl_total = 0.1
var tail_ttl = tail_ttl_total

var jump_duration = 1.5
var direction: Vector2 = Vector2.ZERO
var jumping = false
var falling = false
var original_position
var first_coso = true

@export var tail_segments: Array[Node2D]  # Referencia a las partes de la cola
var previous_positions: Array[Vector2] = []

func _my_ready():
	Global.BOSS_DEAD = false
	add_to_group("bosses")
	Global.gotoBOSS = true

func _ready():
	Global.CHROM_FX.visible = false
	_my_ready()
	pick_new_direction()
	$Timer.wait_time = randf_range(1, 3)
	$Timer.start()

func _process(delta):
	if jumping or falling:
		tail_ttl = tail_ttl_total
		if !$Head.visible:
			tail_visible()
			if first_time:
				first_time = false
		
		$Head.visible = true
		for _i in range(tail_segments.size()):
			if _i % 2 == 0:
				tail_segments[_i].rotation_degrees += 10 * delta
			else:
				tail_segments[_i].rotation_degrees -= 10 * delta
		
		$water_drops.visible = false
		$Head.flip_h = x_direction == -1
		$Head/Head.flip_h = x_direction == -1
		apply_jump(delta)
		update_tail()
	else:
		if $Head.visible:
			if first_time:
				tail_hide()
		else:
			if tail_ttl <= 0:
				tail_ttl = tail_ttl_total
				tail_hide_parts()
			else:
				tail_ttl -= 1 * delta
			
		if $Head.visible:
			$Head.visible = false
			if !first_time:
				Global.player_obj.force_thunder()
				for _i in tail_segments.size():
					splash()
				
		$water_drops.visible = true
		ttl_drop -= 1 * delta
		if moving:
			create_drop(global_position)
			velocity = direction * speed
			move_and_slide()
			update_tail()
			check_bounds()
			
func tail_visible():
	for _i in tail_segments.size():
		#await get_tree().create_timer(0.1).timeout
		tail_segments[_i].visible = true
		splash()
		
func tail_hide():
	for _i in tail_segments.size():
		#if !first_time:
			#await get_tree().create_timer(0.1).timeout
		tail_segments[_i].visible = false
		if !first_time:
			splash()
			
func tail_hide_parts():
	for _i in tail_segments.size():
		if tail_segments[_i].visible:
			tail_segments[_i].visible = false
			mini_splash(tail_segments[_i])
			return
			
func update_tail():
	previous_positions.insert(0, global_position)
	var segment_spacing = 10.0
	for i in range(tail_segments.size()):
		var target_index = (i + 1) * segment_spacing
		if target_index < previous_positions.size():
			tail_segments[i].global_position = previous_positions[target_index]
	
	previous_positions.resize(tail_segments.size() * segment_spacing)
		
func create_drop(pos):
	if ttl_drop <= 0:
		ttl_drop = 0.5
		var drop = waterdrop.instantiate()
		drop.position = pos
		drop.scale.x = 1.906
		drop.scale.y = 1.906
		get_parent().add_child(drop)

func pick_new_direction():
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	
func check_bounds():
	var viewport_rect = get_viewport_rect()

	if global_position.x <= 100 or global_position.x + 100 >= viewport_rect.size.x:
		count -= 1
		pick_new_direction()

	if global_position.y <= 100 or global_position.y + 100 >= viewport_rect.size.y:
		count -= 1
		pick_new_direction()
		
func all_tail_invisible():
	for _i in tail_segments.size():
		if tail_segments[_i].visible:
			return false
			
	return true

func start_jump():
	if !all_tail_invisible():
		return false
	
	if jumping or falling or global_position.y <= 300:
		return false
		
	if global_position.x > 1152 / 2:
		x_direction = -1
	else:
		x_direction = 1
		
	if first_coso:
		first_coso = false
		Global.boss_bar.showme("GUSANON")
		Ambience.stop()
		Music.stop()
		Music.play(Global.BossTheme)
	
	splash()
	Global.player_obj.force_thunder()
	jumping = true
	falling = false
	original_position = global_position
	$JumpTimer.start(jump_duration) 
	return true
	
func mini_splash(tail_segment):
	var sp = watersplash.instantiate()
	sp.global_position = Vector2(tail_segment.global_position.x, tail_segment.global_position.y)
	get_parent().add_child(sp)
	
func splash():
	var count = randi_range(1, 2)
	for i in range(count):
		var sp = watersplash.instantiate()
		sp.global_position = Vector2(global_position.x, global_position.y + 48)
		get_parent().add_child(sp)

func apply_jump(delta):
	if jumping:
		global_position.y -= jumpspeed * delta
		global_position.x += speed * delta * x_direction
	elif falling:
		global_position.y += speed * delta
		global_position.x += speed * delta * x_direction
		if global_position.y >= original_position.y:
			global_position.y = original_position.y 
			falling = false
			jumping = false
			$JumpTimer.stop()
			$Timer.wait_time = randf_range(3, 5)
			$Timer.start()

func _on_timer_timeout():
	if count <= 0:
		count = count_total
		if start_jump():
			$Timer.stop()
	else:
		count -= 1
		pick_new_direction()
		$Timer.stop()
		$Timer.wait_time = randf_range(3, 5)
		$Timer.start()

func _on_jump_timer_timeout():
	jumping = false
	falling = true
