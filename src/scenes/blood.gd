extends Area2D

var is_colliding = false
var is_colliding_temp = false

var vspeed = randf_range(-5.0,5.0)
var hspeed = randf_range(-3.0,3.0)

var blood_acc = randf_range(0.05,0.1)


var do_wobble = false

var max_count = randf_range(5.0, 190.0)
var count  = 0

@onready var draw_surface : paint = get_node("/root/Main/Surface")

func _ready():
	add_to_group("bloods")
	set_as_top_level(true)

func _physics_process(_delta: float) -> void:
	if(!is_colliding): # in the air
		do_wobble = false
		vspeed = lerp(vspeed, 5.0, 0.02)
		hspeed = lerp(hspeed, 0.0, 0.02)
		visible = true
		
	else: # touching platform
		if is_colliding_temp:
			draw_surface.draw_blood_temp(position) # draw blood to surface
		else:	
			draw_surface.draw_blood(position) # draw blood to surface
		
		#Count increase until max_count, then delete
		count += 1
		if(count > max_count): 
			queue_free()
		
		#We make sure blood drop faster than 3, slowly reduce speed
		if (vspeed > 3.0) : vspeed = 3.0
		vspeed = lerp(vspeed,0.1,blood_acc)
		
		#If we're moving downwards in a line, add wobble
		if(hspeed > 0.1 or hspeed < -0.1):
			hspeed = lerp(hspeed,0.0,0.1)
		else:
			do_wobble = true

		visible = false
		
	#we add random wobble when moving downwards to avoid str8 lines
	if(do_wobble):
		hspeed += randf_range(-0.01,0.01)
		hspeed = clamp(hspeed,-0.1,0.1)
		
	#update our position based on the vspeed and hspeed
	position.y += vspeed
	position.x += hspeed

func _on_body_entered(body):
	if body.is_in_group("movebable"):
		is_colliding_temp = true
		
	if !(body.is_in_group("players") or body.is_in_group("enemies") or body.is_in_group("interactuable")):
		is_colliding = true

func _on_body_exited(body):
	if !(body.is_in_group("players") or body.is_in_group("enemies") or body.is_in_group("interactuable")):
		is_colliding = false
