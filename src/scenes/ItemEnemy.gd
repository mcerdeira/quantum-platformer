extends Area2D
var current_item = null
var active = false
var opened = false
var player = null
var delay_camera = 0.2
var QTY = 1

func _ready():
	$display.visible = false
	current_item = Global.coin
	QTY = Global.pick_random([10, 15, 20])
	$display/back/sprite.animation = current_item.name
	var qty_str = ""
	if QTY != 1:
		qty_str = " (x" + str(QTY) + ")"
	$display/back/lbl_item.text = "== " + current_item.friendly_name.to_upper() + qty_str + " ==" + "\n" + current_item.description

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
	Global.get_item(current_item, QTY)
	queue_free()

func _on_body_entered(body):
	if visible:
		if !opened and body.is_in_group("players") and !body.is_in_group("prisoners"):
			body.dont_camera = true
			$display.visible = true
			var center = Global.shaker_obj.camera.get_screen_center_position()
			$display.global_position = center
			active = true
			player = body

func _on_body_exited(body):
	if visible:
		if body.is_in_group("players") and !body.is_in_group("prisoners"):
			body.dont_camera = false
			$display.visible = false
			active = false
			body.dont_camera = false
