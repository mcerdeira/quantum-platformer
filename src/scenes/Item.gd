extends Area2D
var current_item = null
var active = false
var opened = false
var player = null
var delay_camera = 0.2
var QTY = 1
var has_artifact = false
var itemfound = load("res://scenes/Item3D.tscn")

func _ready():
	$display.visible = false
	if !Global.artifactPicked:
		if !Global.ARTIFACT_PER_LEVEL[Global.TerminalNumber]:
			if randi() % 25 == 0:
				Global.artifactPicked = true
				has_artifact = true
				
	if has_artifact:
		$display/back/lbl_item.text = "== ITEM DESCONOCIDO =="
		$display/back/sprite.animation = "unknown"
	elif randi() % 2 == 0:
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
			$sprite.animation = "open"
			$display.visible = false
		
func get_item():
	if has_artifact:
		Global.ARTIFACT_PER_LEVEL[Global.TerminalNumber] = true
		var p = itemfound.instantiate()
		var parent = get_parent()
		parent.add_child(p)
		$display.visible = false
	else:
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
