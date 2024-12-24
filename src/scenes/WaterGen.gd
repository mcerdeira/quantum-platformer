extends Node2D
#Water Gen with Physics2DServer
@export var particle_texture1:Texture
@export var particle_texture2:Texture
@export var particle_texture3:Texture
@export var particle_texture4:Texture
@export var particle_texture5:Texture
@export var max_water_particles = 500
var current_particle_count = 0
var spawn_timer = 0
@export var spawn_time = 1.0
var water_particles = []
var water_positions = []

func stop():
	max_water_particles = 0

func create_particle():
	var ps = PhysicsServer2D
	var vs = RenderingServer
	# set position
	var trans = global_transform 
	trans.origin += Vector2(randf_range(-10,10),randf_range(-10,10))
	#physics body
	var water_col = ps.body_create()
	ps.body_set_mode(water_col,PhysicsServer2D.BODY_MODE_RIGID)
	ps.body_set_space(water_col,get_world_2d().space)
	
	#set collision layer and mask
	var layer = 1 << 16
	ps.body_set_collision_layer(water_col, layer)
	ps.body_set_collision_mask(water_col, layer)
	
	var shape = ps.circle_shape_create()
	ps.shape_set_data(shape, 5.0)
	ps.body_add_shape(water_col,shape, Transform2D.IDENTITY, false)
	
	#set physics parameters
	ps.body_set_param(water_col,PhysicsServer2D.BODY_PARAM_FRICTION,0.0)
	ps.body_set_param(water_col,PhysicsServer2D.BODY_PARAM_MASS, 0.001)
	ps.body_set_param(water_col,PhysicsServer2D.BODY_PARAM_GRAVITY_SCALE, 0.5)
	ps.body_set_state(water_col,PhysicsServer2D.BODY_STATE_TRANSFORM,trans)

	#Visual
	#create canvas item(all 2D objects are canvas items)
	
	var water_particle = vs.canvas_item_create()
	#set the parent to this object
	vs.canvas_item_set_parent(water_particle, get_canvas_item())
	#set its transform
	vs.canvas_item_set_transform(water_particle,trans)
	#create a rectangle that will contain the texture
	var part_array = [particle_texture1, particle_texture2, particle_texture3, particle_texture4, particle_texture5]	
	var rect = Rect2()
	rect.position = Vector2(-8,-8)
	var particle_texture = Global.pick_random(part_array)
	rect.size = particle_texture.get_size()/ Global.pick_random([2, 1.1, 1.4])

	#add the texture to the canvas item
	vs.canvas_item_add_texture_rect(water_particle,rect,particle_texture)
	
	#set the texture color to pink
	#vs.canvas_item_set_self_modulate(water_particle,Color("ff00ff"))
	#add RID pair to array
	water_particles.append([water_col,water_particle])
	
func _physics_process(delta):
	#add particles while less than max amount set and timer < 0
	if spawn_timer < 0 and current_particle_count < max_water_particles:
		create_particle()
		current_particle_count += 1
		Global.total_water_particles += 1
		spawn_timer = spawn_time
	spawn_timer -= 1
	#update particle texture position to be at Rigid body position
	water_positions = []
	for col in water_particles:
		var trans = PhysicsServer2D.body_get_state(col[0],PhysicsServer2D.BODY_STATE_TRANSFORM)
		trans.origin = trans.origin - global_position
		RenderingServer.canvas_item_set_transform(col[1],trans)
		
		water_positions.append(trans.origin) 
		
		#Delete particles if Y position > than 1500. 2D y down is positive
		if trans.origin.y > global_position.y + 500:
			#remove RIDs
			PhysicsServer2D.free_rid(col[0])
			RenderingServer.free_rid(col[1])
			#remove reference
			water_positions.erase(trans.origin)
			water_particles.erase(col)
			current_particle_count -= 1
			Global.total_water_particles -=1
