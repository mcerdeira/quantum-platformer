shader_type canvas_item;

uniform bool blacked;
uniform bool crisis;

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
	if(blacked){
    	COLOR = vec4(mix(texture_color.rgb, vec3(0,0,0), 1), texture_color.a);
	}
	else if(crisis){
		COLOR = vec4(mix(texture_color.rgb, vec3(1,0,0), 1), texture_color.a);
	}
	else{
		COLOR = vec4(texture_color.rgb, texture_color.a);
	}
}