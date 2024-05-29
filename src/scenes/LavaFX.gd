extends ColorRect

func _ready():
	Global.lava_FX = self

func set_intensity(val, temp):
	print(temp)
	if val <= 0:
		visible = false
	else:	
		material.set_shader_parameter("heatAmplitude", val)
		material.set_shader_parameter("temperatureRange", temp)
		print(temp)
		visible = true
