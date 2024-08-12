extends ColorRect

func _ready():
	Global.lava_FX = self
	set_intensity(0.0, 0.0)

func set_intensity(val, temp):
	if val <= 0.0000002190741:
		visible = false
	else:	
		material.set_shader_parameter("heatAmplitude", val)
		material.set_shader_parameter("temperatureRange", temp)
		visible = true
