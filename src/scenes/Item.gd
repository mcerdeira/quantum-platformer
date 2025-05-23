extends Area2D
var current_item = null
var active = false
var opened = false
var player = null
var delay_camera = 0.2
var QTY = 1
@export var fixed = false

func _ready():
	$display.visible = false
				
	if randi() % 2 == 0 or fixed:
		current_item = Global.pick_random(Global.gunz_objs_prob)
		if current_item.name == "bomb":
			QTY = Global.pick_random([5, 8, 10])
		elif current_item.name == "smoke":
			QTY = Global.pick_random([5, 8, 10])
		elif current_item.name == "coin":
			QTY = Global.pick_random([1, 5, 8])
		elif current_item.name == "muffin":
			QTY = Global.pick_random([5, 8, 10])
		elif current_item.name == "spring":
			QTY = Global.pick_random([5, 8, 10])
		elif current_item.name == "clone":
			QTY = Global.pick_random([5, 8, 10])
		elif current_item.name == "teleport":
			QTY = Global.pick_random([5, 8, 10])
		elif current_item.name == "plant":
			QTY = Global.pick_random([5, 8, 10])
		
		$display/back/sprite.animation = current_item.name
		var qty_str = ""
		if QTY != 1:
			qty_str = " (x" + str(QTY) + ")"
		
		$display/back/lbl_item.text = "== " + current_item.friendly_name.to_upper() + qty_str + " ==" + "\n" + current_item.description
	else:
		queue_free()

func _physics_process(delta):
	if !active and opened:
		if player:
			if delay_camera > 0:
				delay_camera -= 1 * delta
				if delay_camera <= 0:
					player.dont_camera = false
	
	if active and !opened:
		if Input.is_action_just_pressed("up"):
			Global.play_sound(Global.InteractSFX)
			Global.play_sound(Global.ChestOpenSFX)
			opened = true
			active = false
			Global.emit(global_position, 5)
			get_item()
			var show_video = false
			if current_item.name == "smoke" and Global.first_time_smoke:
				Global.first_time_smoke = false
				show_video = true
			
			if current_item.name == "plant" and Global.first_time_plant:
				Global.first_time_plant = false
				show_video = true
				
			if current_item.name == "clone" and Global.first_time_clone:
				Global.first_time_clone = false
				show_video = true
				
			if current_item.name == "teleport" and Global.first_time_teleport:
				Global.first_time_teleport = false
				show_video = true
				
			if current_item.name == "muffin" and Global.first_time_muffin:
				Global.first_time_muffin = false
				show_video = true
				
			if current_item.name == "bomb" and Global.first_time_bomb:
				Global.first_time_bomb = false
				show_video = true
				
			if current_item.name == "spring" and Global.first_time_spring:
				Global.first_time_spring = false
				show_video = true
				
			if show_video:
				Global.video_tutorial.play(current_item)
					
			$sprite.animation = "open"
			$display.visible = false
		
func get_item():
	Global.get_item(current_item, QTY)

func _on_body_entered(body):
	if !opened and body.is_in_group("players") and !body.is_in_group("prisoners"):
		body.dont_camera = true
		$display.visible = true
		var center = Global.shaker_obj.camera.get_screen_center_position()
		$display.global_position = center
		active = true
		player = body

func _on_body_exited(body):
	if body.is_in_group("players") and !body.is_in_group("prisoners"):
		body.dont_camera = false
		$display.visible = false
		active = false
		body.dont_camera = false
