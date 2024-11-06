extends Area2D
var closed = true
var nope = false
var target = null
var opening = false
var closing = false
var closing_ttl = 0.5
var opening_tl = 0.5
var offset = 0.0
var entering = false
@export var terminal_number = -1
@export var gotoBOSS = true
@export var special_door = false 
@export var shop_door = false

func _ready():
	if terminal_number != -1:
		$sprite.animation = str(terminal_number)
		
	if special_door:
		add_to_group("special_doors")
		$sprite.animation = "special"
		open(false)
		
	if shop_door:
		add_to_group("special_doors")
		$sprite.animation = "shop"
		if Global.CurrentState == Global.GameStates.SHOP:
			open(false)
		else:
			if Global.TOMB_STATUS or Global.MERMAID_STATUS or Global.SALAMANDER_STATUS or Global.SERAPH_STATUS:
				open(false)
			
	if !gotoBOSS and !special_door and !shop_door:
		if terminal_number == -1:
			if !nope:
				Global.exit_door = self
		else:
			var change = Global.sync_this_terminal(terminal_number)
			if Global.Terminals[terminal_number].status:
				open(change)
			else:
				close(change)
				
func _physics_process(delta):
	if opening:
		$sprite.material.set_shader_parameter("offset", offset)
		offset += opening_tl * delta
		if offset >= 1:
			reallyopen()
			opening = false
		return
		
	if closing:
		$sprite.material.set_shader_parameter("offset", offset)
		offset -= closing_ttl * delta
		if offset <= 0:
			reallyclose()
			closing = false
		return
	
	if !closed and target:
		if Input.is_action_pressed("up") or entering:
			entering = true
			target.dont_camera = true
			target.hide_eyes()
			target.global_position.x = global_position.x
			target.modulate.a -= 2 * delta
			if target.modulate.a <= 0:
				Global.scene_next(terminal_number, gotoBOSS, special_door, shop_door)

func assign(_terminal_number):
	if !special_door and !shop_door:
		terminal_number = _terminal_number
		Global.exit_door = self

func open(with_sound = false):
	if (gotoBOSS or with_sound) and !special_door and !shop_door:
		opening = true
		$Timer.start()
		$sprite_open.visible = true
		opening_tl = 0.3
		var options = {"pitch_scale": 0.7}
		Global.play_sound(Global.DoorOpensSFX, options)
		Global.shaker_obj.shake(15, 3)
	else:
		reallyopen()
		
func close(with_sound = false):
	if (gotoBOSS or with_sound) and !special_door and !shop_door:
		$sprite.frame = 0
		offset = 1.0
		$sprite.material.set_shader_parameter("offset", 1)
		closing = true
		$Timer.start()
		$sprite_open.visible = true
		closing_ttl = 0.3
		var options = {"pitch_scale": 0.7}
		Global.play_sound(Global.DoorOpensSFX, options)
		Global.shaker_obj.shake(15, 3)
	else:
		reallyclose()
		
func reallyclose():
	$Timer.stop()
	closed = true
	$sprite_open.visible = false
	$sprite.material.set_shader_parameter("offset", 0)
	$sprite.frame = 0

func reallyopen():
	$Timer.stop()
	closed = false
	$sprite_open.visible = false
	$sprite.material.set_shader_parameter("offset", 0)
	$sprite.frame = 1

func _on_body_entered(body):
	if Global.player_obj and is_instance_valid(Global.player_obj) and Global.player_obj.is_on_floor_custom():
		if !closed and !closing and !opening and body.is_in_group("players"):
			target = body

func _on_body_exited(body):
	if Global.player_obj and is_instance_valid(Global.player_obj) and Global.player_obj.is_on_floor_custom():
		if !closed and !closing and !opening and body.is_in_group("players"):
			target = null
