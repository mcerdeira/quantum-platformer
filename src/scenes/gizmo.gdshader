shader_type canvas_item;

uniform bool blacked;
uniform bool crisis;

uniform vec4 shine_color : source_color = vec4(1.0);
uniform float shine_speed : hint_range(0.0, 10.0, 0.1) = 1.0;
uniform float shine_size : hint_range(0.01, 1.0, 0.01) = 0.01;
uniform float white;
uniform bool gizmomode = true;

void fragment() {
	if(gizmomode){
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
	} else {
		if(white>0.0){
			vec4 texture_color = texture(TEXTURE, UV);
	    	COLOR = vec4(mix(texture_color.rgb, vec3(1,1,1), white), texture_color.a);
		}else{
			COLOR = texture(TEXTURE, UV);
			float shine = step(1.0 - shine_size * 0.5, 0.5 + 0.5 * sin(UV.x - UV.y + TIME * shine_speed));
			COLOR.rgb = mix(COLOR.rgb, shine_color.rgb, shine * shine_color.a);
		}
	}
}