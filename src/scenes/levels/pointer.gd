extends CharacterBody2D
var started = false
var is_ready = false

func _ready():
	add_to_group("interactuable")
	Global.Fader.fade_out()

func _physics_process(_delta):
	velocity = Input.get_last_mouse_velocity()
	global_position = get_global_mouse_position()
	if Input.is_action_just_pressed("start_gamepad"):
		Global.gamepad = 1
	
	if Input.is_action_just_pressed("start") or Input.is_action_just_pressed("jump"):
		if !started:
			started = true
			Global.play_sound(Global.PressStartSFX)
			$"../AnimationPlayer".play("new_animation")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	is_ready = true
