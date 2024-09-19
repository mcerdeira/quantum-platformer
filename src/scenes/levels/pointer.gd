extends CharacterBody2D
var started = false

func _ready():
	add_to_group("interactuable")
	Global.Fader.fade_out()

func _physics_process(_delta):
	velocity = Input.get_last_mouse_velocity()
	global_position = get_global_mouse_position()
	if Input.is_action_just_pressed("start"):
		if !started:
			started = true
			Global.play_sound(Global.PressStartSFX)
			
		$"../PStart/AnimationPlayer".speed_scale = 10
		$"../Timer".start()

func _on_timer_timeout():
	Global.scene_next()
