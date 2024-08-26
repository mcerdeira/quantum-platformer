extends ColorRect

func _ready():
	Global.lava_FX = self
	set_intensity(0.0, 0.0)

func set_intensity(val, temp):
	if val <= 0.0000002190741:
		$"../WorldEnvironment".environment.glow_intensity = 0.2
		visible = false
	else:	
		if temp >= 0.8:
			$"../WorldEnvironment".environment.glow_intensity = lerp($"../WorldEnvironment".environment.glow_intensity, 0.8, 0.1)
		else:
			$"../WorldEnvironment".environment.glow_intensity = lerp($"../WorldEnvironment".environment.glow_intensity, 0.2, 0.1)
		material.set_shader_parameter("heatAmplitude", val)
		material.set_shader_parameter("temperatureRange", temp)
		visible = true
