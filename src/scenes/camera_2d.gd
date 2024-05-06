extends Camera2D

# How far ahead, is seconds we want each player to see
# based on their current velocity
@export_range(0,1,0.05) var STEP_SECS := 0.3 

# Extra breathing room at the edges of the camera frame
@export var PADDING := 100

@export_range(0, 2, 0.01) var MIN_ZOOM := 0.45
@export_range(0, 2, 0.01) var MAX_ZOOM := 1.0

# How quickly to track the camera ( 0 == instant, 0.5, halfway per second, 1 == stopped )
@export_range(0, 1, 0.01) var TRACK_SPEED := 0.1 

# Idem when zooming out and in
@export_range(0, 1, 0.01) var ZOOM_OUT_SPEED := 0.2 
@export_range(0, 1, 0.01) var ZOOM_IN_SPEED := 0.6 

var viewport_size : Vector2
var center_point : Vector2
var zoom_factor : Vector2

func _ready() -> void:
	Global.main_camera = self
	viewport_size = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	if Global.targets.is_empty():
		return
	
	var player_rect := Rect2()
	
	# Expand the rect to include the rest of the positions
	for player in Global.targets:
		player_rect = player_rect.expand(player.position + player.velocity * STEP_SECS)
	
	# Add some extra padding
	player_rect = player_rect.grow(PADDING)
	
	# The proportion between the viewport size and our rect size gives us the
	# required zoom value
	var zoom_factor_x = float(viewport_size.x  / player_rect.size.x)
	var zoom_factor_y = float(viewport_size.y  / player_rect.size.y)
	# We want a uniform zoom factor so we choose the one that shows the most
	# We also want it to stay within certain values
	zoom_factor = Vector2.ONE * clamp( min(zoom_factor_x, zoom_factor_y), MIN_ZOOM, MAX_ZOOM)
	# The position of the camera is simply the center of the rect
	center_point = player_rect.get_center()


func _process(delta: float) -> void:
	if Global.targets.is_empty():
		return
	# The lerping between current and target values can happen in process
	position = lerp(position, center_point, 1 - pow(TRACK_SPEED,delta) )
	
	# A quick zoom out to keep everyone in frame is important, but a quick zoom in
	# can be confusing, so we can use different values depending on what we're doing
	var zoom_speed = ZOOM_IN_SPEED if zoom_factor > zoom else ZOOM_OUT_SPEED
	zoom = lerp(zoom, zoom_factor, 1 - pow(zoom_speed, delta) )
	
	
func register_target(target : Node2D):
	if not target in Global.targets:
		Global.targets.append(target)
	
func unregister_target(target : Node2D):
	if target in Global.targets:
		Global.targets.erase(target)
