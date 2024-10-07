extends Camera2D
@export var zoom_final : Vector2 = Vector2(0, 0)
@export var zoom_speed = 0.1

func _ready():
	Global.shaker_obj.camera = self

func _process(_delta):
	Global.shaker_obj.camera = self

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "phase1":
		$"../AnimationPlayer".play("phase2")
	elif anim_name == "phase2":
		$"../AnimationPlayer".play("phase3")

func shake():
	Global.shaker_obj.shake(15, 3)
	Global.play_sound(Global.BOSS1RoarSFX)
