extends Area2D
var current_item = null
var active = false
var opened = false

func _ready():
	if randi() % 4 == 1:
		current_item = Global.pick_random(Global.gunz_objs_prob)
		$back/sprite.animation = current_item.name
		$back/lbl_item.text = "== " + current_item.name.to_upper() + " ==" + "\n" + current_item.description
	else:
		queue_free()

func _physics_process(delta):
	$back2.visible = $back.visible 
	if active and !opened:
		if Input.is_action_just_pressed("up"):
			opened = true
			active = false
			Global.emit(global_position, 5)
			get_item()
			$sprite.animation = "open"
			$back.visible = false
		
func get_item():
	Global.get_item(current_item)

func _on_body_entered(body):
	if !opened and body.is_in_group("players") and !body.is_in_group("prisoners"):
		$back.visible = true
		active = true

func _on_body_exited(body):
	if !opened and body.is_in_group("players") and !body.is_in_group("prisoners"):
		$back.visible = false
		active = false
