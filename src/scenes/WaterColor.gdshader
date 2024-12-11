shader_type canvas_item;

uniform float color_detect_threshold = 0.6;
//suggest color code: ff00ff
uniform vec4 water_dev_color: source_color;
uniform vec4 water_color:source_color = vec4(0,0,1,1);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment(){
	//2 UV references from Screen
	vec2 suv = SCREEN_UV;
	vec2 buv = SCREEN_UV;
	//get a blurred version of the screen texture
	vec4 screen_tex = textureLod(SCREEN_TEXTURE,SCREEN_UV,1.1).rgba;
	vec4 particle_color;
	//check if the color is pink i.e ff00ff
	//if it is set it to the new color else set it to transparent
	if(step(color_detect_threshold,screen_tex) == water_dev_color){
		
		particle_color = water_color;
	}else{
		//transparent
		particle_color = vec4(0.0);
	}
	//assign final color
	COLOR = particle_color;
}