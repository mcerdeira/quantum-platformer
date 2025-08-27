extends ParallaxBackground

func _ready() -> void:
	Global.FogObj = self
			
func _on_timer_timeout():
	visible = true
