extends Area2D
var current_item = null
var active = false
var opened = false
var player = null
var delay_camera = 0.2
var tomb = load("res://scenes/Tomb.tscn")
var killme = false
var QTY = 1

func _ready():
	$display.visible = false
	if randi() % 3 == 0:
		current_item = Global.pick_random(Global.gunz_objs_prob)
		if current_item.name == "bomb":
			QTY = Global.pick_random([2, 3, 5])
		elif current_item.name == "smoke":
			QTY = Global.pick_random([2, 3, 5])
		elif current_item.name == "coin":
			QTY = Global.pick_random([1, 5, 10])
		elif current_item.name == "muffin":
			QTY = Global.pick_random([2, 3, 5])
		
		$display/back/sprite.animation = current_item.name
		var qty_str = ""
		if QTY != 1:
			qty_str = " (x" + str(QTY) + ")"
		
		$display/back/lbl_item.text = "== " + current_item.name.to_upper() + qty_str + " ==" + "\n" + current_item.description
	else:
		if randi() % 3 == 0:
			killme = true
		else:
			queue_free()

func _physics_process(delta):
	if killme:
		var p = tomb.instantiate()
		var parent = get_parent()
		parent.add_child(p)
		p.global_position = global_position
		queue_free()
		return
	
	if !active and opened:
		if player:
			if delay_camera > 0:
				delay_camera -= 1 * delta
				if delay_camera <= 0:
					player.dont_camera = false
	
	if active and !opened:
		if Input.is_action_just_pressed("up"):
			opened = true
			active = false
			Global.emit(global_position, 5)
			get_item()
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
