extends Area2D

func _ready():
	add_to_group("stairs")

func _on_body_entered(body):
	if body.is_in_group("players"):
		pass
		#body.is_on_stairs = true
		#body.grabbed = false

func _on_body_exited(body):
	if body.is_in_group("players"):
		pass
		#body.is_on_stairs = false
		#body.grabbed = false
