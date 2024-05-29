extends ColorRect

func _ready():
	Global.lava_FX = self

func set_intensity(val, temp):
	material.set_shader_parameter("heatAmplitude", val)
	material.set_shader_parameter("temperatureRange", temp)
