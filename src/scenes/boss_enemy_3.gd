extends CharacterBody2D
var waterdrop = preload("res://scenes/water_drp.tscn")
var watersplash = preload("res://scenes/Confeti.tscn")
var ttl_drop = 0.0
var moving = true
var splash_ttl_total = 0.2
var splash_ttl = 0
var x_direction = 0
var jumpspeed = 60
var speed: float = 200.0
var TOTAL_LIFE = 1.0 #12.0
var LIFE = TOTAL_LIFE
var first_time = true
var tail_ttl_total = 0.1
var tail_ttl = tail_ttl_total
var num_bullets = 65
var attack_duration = 6.5
var attack_rot = 0
var jump_duration = 1.5
var direction: Vector2 = Vector2.ZERO
var jumping = false
var falling = false
var shoot_ttl = 0
var shoot_ttl_total = 2.3
var attacking = false
var original_position
var first_coso = true
var backwards = false
var dead = false
var blowed = 0.0
const FireBallHolderShoot = preload("res://scenes/FireBallHolderShoot.tscn")
@export var H_Pos_U : Node2D
@export var H_Pos_D : Node2D
@export var V_Pos_L : Node2D
@export var V_Pos_R : Node2D
@export var C_Pos : Node2D
var Pos_Dir = null

var Address_Matrix_Idx = -1
var Address_Matrix = []

@export var tail_segments: Array[Node2D]  # Referencia a las partes de la cola
var previous_positions: Array[Vector2] = []

func _my_ready():
	Global.BOSS_DEAD = false
	add_to_group("bosses")
	Global.gotoBOSS = true
	
func shoot():
	attack_rot += 10
	for i in range(num_bullets):
		var p = FireBallHolderShoot.instantiate()
		var parent = get_parent()
		p.global_position = $BossModeShoot/Head.global_position
		p.direction = Vector2.RIGHT.rotated(360 * (i + attack_rot))
		parent.add_child(p)
		Global.emit($BossModeShoot/Head.global_position, 5)

func _ready():
	Address_Matrix = [H_Pos_U, C_Pos, V_Pos_R, C_Pos, H_Pos_D, C_Pos, V_Pos_L, C_Pos]
	Global.CHROM_FX.visible = false
	_my_ready()
	pick_new_direction()

func _process(delta):
	if dead:
		var fireballholder = get_tree().get_nodes_in_group("fireballholder")
		for e in fireballholder:
			e.queue_free()
			
		var fireball = get_tree().get_nodes_in_group("fireball")
		for e in fireball:
			e.queue_free()
		
		if visible:
			splash_ttl -= 1 * delta
			if splash_ttl <= 0:
				splash_ttl = splash_ttl_total
				splash(0)
	else:
		if blowed > 0:
			blowed -= 1 * delta
		
		if attacking:
			$water_drops.visible = true
			if $Head.visible:
				for _i in tail_segments.size():
					tail_segments[_i].visible = true
			$Head.visible = false
			if Global.player_obj.global_position.x > global_position.x:
				$BossModeShoot/Head.scale.x = 1
			else:
				$BossModeShoot/Head.scale.x = -1
				
			shoot_ttl -= 1 * delta
			if shoot_ttl <= 0:
				shoot_ttl = shoot_ttl_total
				shoot()
		
		elif jumping or falling:
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
	var segment_spacing = 7.0
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
		
func flyaway():
	if blowed <= 0:
		LIFE -= 1.0
		Global.play_sound(Global.BOSS1RoarSFX)
		if LIFE <= 0.0:
			force_kill()
			
		Global.shaker_obj.shake(3, 0.5)
		Global.boss_bar.calc_life_bar(TOTAL_LIFE, LIFE)
		blowed = 3.5

func pick_new_direction():
	Address_Matrix_Idx += 1
	if Address_Matrix_Idx > 7:
		Address_Matrix_Idx = 0
		
	Pos_Dir = Address_Matrix[Address_Matrix_Idx].get_random_point()
	direction = global_transform.origin.direction_to(Pos_Dir)
	
func check_bounds():
	var viewport_rect = get_viewport_rect()
	var dist = global_position.distance_to(Pos_Dir)
	if dist <= 10:
		if Address_Matrix_Idx % 2 != 0:
			decide()
		else:
			if Address_Matrix_Idx == 4: #H_Pos_D
				if randi() % 2 == 0:
					pick_new_direction()
				else:
					start_attack()
			else:
				pick_new_direction()
		
func all_tail_invisible():
	for _i in tail_segments.size():
		if tail_segments[_i].visible:
			return false
			
	return true
	
func start_attack():
	if !all_tail_invisible():
		return false
	
	if jumping or falling or attacking:
		return false
		
	$BossModeShoot.visible = true
	$BossModeShoot/AnimationPlayer.play("new_animation")
	shoot_ttl = 150
	Global.player_obj.force_thunder()
	attacking = true
	$AttackTimer.start(attack_duration) 
	return true

func start_jump():
	if !all_tail_invisible():
		return false
	
	if attacking or jumping or falling:
		return false
		
	#1 viene de arriba
	#3 viene de la derecha
	#5 viene de abajo
	#7 viene de la izquierda
	if Address_Matrix_Idx == 3:
		x_direction = -1
	elif Address_Matrix_Idx == 7:
		x_direction = 1
	if randi() % 2 == 0:
		x_direction = -1
	else:
		x_direction = 1
		
	if first_coso:
		first_coso = false
		Global.boss_bar.showme("GUSANON")
		Ambience.stop()
		Bees.stop()
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
	
func splash(ajust = 48):
	var count = randi_range(1, 2)
	for i in range(count):
		var sp = watersplash.instantiate()
		sp.global_position = Vector2(global_position.x, global_position.y + ajust)
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
			pick_new_direction()
			$JumpTimer.stop()
			
func force_kill():
	LIFE = 0.0
	dead = true
	die()
			
func die():
	Global.ARTIFACT_PER_LEVEL[Global.TerminalNumber] = true
	Global.LEAF_STATUS = false
	Global.TOMB_STATUS = false
	Global.MERMAID_STATUS = false
	Global.SALAMANDER_STATUS = true
	Global.FromPipe = true
	Global.gotoBOSS = false
	Global.BOSS_DEAD = true
	Global.shaker_obj.shake(8, 5.1)
	var play_anim = false 
	if !attacking or attacking and backwards:
		play_anim = true
	
	attacking = false
	jumping = false
	falling = false
	backwards = false
	$Head.visible = false
	tail_hide()
	splash(0)
	$BossModeShoot.visible = true
	if play_anim:
		$BossModeShoot/AnimationPlayer.play("new_animation")
		
	Global.player_obj.force_thunder()
	await get_tree().create_timer(attack_duration).timeout
	backwards = true
	$BossModeShoot/AnimationPlayer.play_backwards("new_animation")
	Global.player_obj.force_thunder()
	finishup()
	
func finishup():
	splash()
	Music.stop()
	Ambience.play(Global.RainAmbienceSFX)
	visible = false
	Global.player_obj.locked_ctrls = true
	Global.player_obj.show_message()
	await get_tree().create_timer(3.0).timeout
	Global.player_obj.hide_message()
	
func decide():
	if !first_coso and randi() % 2 == 0:
		if start_attack():
			pass
	else:
		if start_jump():
			pass

func _on_jump_timer_timeout():
	jumping = false
	falling = true

func _on_attack_timer_timeout():
	shoot_ttl = 150
	$AttackTimer.stop()
	backwards = true
	$BossModeShoot/AnimationPlayer.play_backwards("new_animation")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if !dead:
		if backwards:
			backwards = false
			$BossModeShoot.visible = false
			shoot_ttl = 0
			attack_rot = 0
			attacking = false
			pick_new_direction()
		else:
			shoot_ttl = 0
	else:
		if backwards:
			$BossModeShoot.visible = false
			splash()

func _on_eat_area_entered(area: Area2D) -> void:
	if !dead:
		if !attacking and $Head.visible:
			if area and area.is_in_group("players"):
				area.killeat()
