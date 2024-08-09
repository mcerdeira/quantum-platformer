extends Area2D
var total_ttl = 8
var ttl = total_ttl
var falling = false
var speed = 180
var initial_position = Vector2.ZERO 

func _ready():
	initial_position = global_position
	
func set_ttl():
	ttl = total_ttl
	
func _physics_process(delta):
	if !falling:
		ttl -= 1 * delta
		$sprite.scale.y = lerp($sprite.scale.y, 1.0, 0.009)
		if ttl <= 0:
			$sprite.scale.y = 1
			ttl = total_ttl
			falling = true
	else:
		global_position.y += speed * delta

func _on_body_entered(_body):
	if falling:
		falling = false 
		$sprite.visible = false
		$particles.emitting = true
		await get_tree().create_timer(0.3).timeout
		global_position = initial_position 
		$sprite.scale.y = 0
		$particles.emitting = false
		$sprite.visible = true

func _on_area_entered(_area):
	if falling:
		falling = false 
		$sprite.visible = false
		$particles.emitting = true
		await get_tree().create_timer(1).timeout
		global_position = initial_position 
		$sprite.scale.y = 0
		$particles.emitting = false
		$sprite.visible = true
		
		
