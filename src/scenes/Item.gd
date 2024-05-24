extends Area2D
var current_item = null
var active = false

func _ready():
	if randi() % 2 == 1:
		current_item = Global.pick_random(Global.gunz_objs)
		$sprite.animation = current_item.name
		$back/lbl_item.text = "== " + current_item.name.to_upper() + " ==" + "\n" + current_item.description
	else:
		queue_free()

func _physics_process(delta):
	if active:
		if Input.is_action_just_pressed("up"):
			active = false
			Global.emit(global_position, 5)
			get_item()
			queue_free()
		
func get_item():
	Global.get_item(current_item)

func _on_body_entered(body):
	if body.is_in_group("players") and !body.is_in_group("prisoners"):
		$back.visible = true
		active = true

func _on_body_exited(body):
	if body.is_in_group("players") and !body.is_in_group("prisoners"):
		$back.visible = false
		active = true
