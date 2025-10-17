shader_type canvas_item;

uniform bool invert_colors = true;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    if (invert_colors) {
        tex.rgb = vec3(1.0) - tex.rgb;
    }
    COLOR = tex;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
