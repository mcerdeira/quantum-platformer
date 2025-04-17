extends Area2D
var active = false
var opened = false
var player = null
var delay_camera = 0.2
var itemfound = load("res://scenes/Artifact3D.tscn")
var has_artifact = false
var initial_message = "== MONOLITO ==\n¿EXAMINAR?"

func _ready():
	$display/back/lbl_item.text = initial_message
	$display/back/sprite.animation = "unknown"
	$display.visible = false
	has_artifact = got_some()
	
func got_some():
	for a in Global.ARTIFACT_PER_LEVEL:
		if a:
			return true
			
	return false

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
			opened = true
			active = false
			Global.emit(global_position, 5)
			get_item()
			
func get_item():
	Global.play_sound(Global.InteractSFX)
	if has_artifact:
		Global.play_sound(Global.AltarSFX)
		var p = itemfound.instantiate()
		add_child(p)
		$display.visible = false
	else:
		$display/back/lbl_item.text = "HAY 4 RANURAS... ¿PARA QUE SON?"
		$display/back/sprite.animation = "monolith"
		
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
		opened = false
		body.dont_camera = false
		$display/back/lbl_item.text = initial_message
		$display/back/sprite.animation = "unknown"
