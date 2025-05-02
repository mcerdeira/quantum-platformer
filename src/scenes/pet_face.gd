extends Node2D
var is_started = false

func _ready() -> void:
	$sprite.play("default")
	
func _physics_process(delta: float) -> void:
	if is_started:
		Global.shaker_obj.shake(5, 1.1)

func started():
	is_started = true
	$sprite.animation = "persecution"
	$sprite.play("persecution")
	Global.player_obj.show_message_custom("¡¡¡AHHHHH!!!", 2.0)
	Global.player_obj.face_override("scared")

func _on_sprite_animation_finished() -> void:
	$sprite.visible = false
	$PetMonster.visible = true
	$PetMonster.play("default")

func _on_pet_monster_animation_finished() -> void:
	if $PetMonster.animation == "default":
		$PetMonster.animation == "wait"
		$PetMonster.play("wait")
		Global.player_obj.locked_ctrls = false
		Global.player_obj.face_override("idle")
