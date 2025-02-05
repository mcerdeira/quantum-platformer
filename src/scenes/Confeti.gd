extends Node2D
var ttl = 6

func _ready():
	$green.emitting = true
	$green2.emitting = true
	$green3.emitting = true
	$green4.emitting = true
	$green5.emitting = true

func _process(delta):
	ttl -= 1 * delta
	if ttl <= 0:
		queue_free()
