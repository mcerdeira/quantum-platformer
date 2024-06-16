extends Node2D
var inside_me = []
var created = false

func _ready():
	create()
		
func create():
	created = true
	$Line2D.points[1].y = 0
	
func destroy():
	created = false
		
func _physics_process(delta):
	if inside_me.size() > 0 and created:
		$Line2D.points[1].y = 0
		$RaySprite.visible = false
	else:
		$RaySprite.visible = true
		$Line2D.points[1].y = lerp($Line2D.points[1].y, ($RayCast2D.cast_point.y - 16), 0.7)
	
	
	var coso = abs($Line2D.points[1].y)
	$RaySprite.scale.x = abs($Line2D.points[1].y - 2)
	$fire_part.position = $Line2D.points[1]
	$RayParticles2.position = $Line2D.points[1]
	
func _on_inhiber_body_entered(body):
	if body.is_in_group("interactuable") and body not in inside_me:
		inside_me.push_back(body)

func _on_inhiber_body_exited(body):
	if body.is_in_group("interactuable") and body in inside_me:
		inside_me.erase(body)
