extends Area2D
var following = false
var follower = null
var speed = 100#213

func _ready() -> void:
	visible = false
	follower = get_parent()

func _physics_process(delta: float) -> void:
	if following:
		follower.progress += speed * delta

func _on_activator_body_entered(body: Node2D) -> void:
	if $"../../../boss".persecution:
		if body and body.is_in_group("players"):
			if !visible:
				following = true
				visible = true
				$"../../../boss".visible = false
			else:
				body.kill()
