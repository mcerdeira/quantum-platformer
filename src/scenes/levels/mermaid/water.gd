extends Node2D
var watersplash = preload("res://scenes/Confeti.tscn")
var splash_ttl_total = 0.1
var splash_ttl = 0
var started = false

func splash():
	var count = randi_range(1, 2)
	for i in range(count):
		var sp = watersplash.instantiate()
		var aju = randi_range(0, 10) * Global.pick_random([1. -1])
		sp.global_position.x = global_position.x + aju
		sp.global_position.y = $sprite.global_position.y + 15
		get_parent().add_child(sp)
		
func do_start():
	started = true
	visible = true

func _physics_process(delta: float) -> void:
	if started:
		$sprite.scale.y -= 50 * delta
		if $sprite.scale.y <= -25:
			$sprite.scale.y = -25
		splash_ttl -= 1 * delta
		if splash_ttl <= 0:
			splash_ttl = splash_ttl_total
			splash()
