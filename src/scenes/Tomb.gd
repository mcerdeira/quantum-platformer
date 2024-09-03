extends Area2D
var active = false
var opened = false
var player = null
var delay_camera = 0.2
var has_artifact = false
var trapped = true
var level_parent = null
var ghost = preload("res://scenes/enemy_ghost.tscn")
var q = -1

func _ready():
	add_to_group("prisoners")
	if randi() % 2 == 0:
		has_artifact = true
		
	$display.visible = false
	$sprite.frame = randi() % 4

func _physics_process(delta):
	if !active and opened:
		if player:
			if delay_camera > 0:
				delay_camera -= 1 * delta
				if delay_camera <= 0:
					player.dont_camera = false
	
	if active and !opened:
		if Input.is_action_just_pressed("up"):
			trapped = false
			opened = true
			active = false
			Global.emit(global_position, 5)
			get_item()
			
func get_item():
	Global.prisoner_counter -= 1
	Global.map_obj.notify_prisoner_done(q)
	if has_artifact:
		$display/back/lbl_item.text = "¡¡MALDICION!!"
		Global.emit(global_position, 10)
		var parent = level_parent
		var p = ghost.instantiate()
		parent.add_child(p)
		p.global_position = global_position
	else:
		$display/back/lbl_item.text = "NO HAY NADA..."
		
	$relased/collider.set_deferred("disabled", false)
	$display/back/sprite.visible = false

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
