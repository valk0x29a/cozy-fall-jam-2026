shader_type canvas_item;

uniform float alpha : hint_range(0.0, 1.0) = 0.5;


void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	texture_color.a *= alpha;
	COLOR = texture_color;
}
