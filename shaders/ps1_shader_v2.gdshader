shader_type spatial;
	
uniform sampler2D albedo : source_color, filter_nearest;
uniform float alpha_scissor : hint_range(0, 1) = 0.5;

void fragment()
{
	vec4 color_base = COLOR;
	vec4 texture_color = texture(albedo, UV);

	ALBEDO = (color_base * texture_color).rgb;
	ALPHA = texture_color.a * color_base.a;
	ALPHA_SCISSOR_THRESHOLD = alpha_scissor;
}