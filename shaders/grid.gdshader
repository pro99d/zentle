shader_type canvas_item;

uniform float square_size = 50.0;
uniform vec2 viewport_size;
uniform vec2 camera_position;
uniform float camera_zoom;
uniform float grid_weight;
uniform vec3 grid_col = vec3(0.5, 0.5, 0.5);
uniform vec3 background_col = vec3(0.2, 0.2, 0.2);

varying float thickness;
varying vec2 world_offset;
varying float cam_zoom_over_s_size;

float round_to_1(float val) {
    return floor(val * 10.0 + 0.5) / 10.0;
}

void vertex(){
	thickness = clamp(round_to_1(grid_weight / square_size * camera_zoom), 0.02, square_size);
	world_offset = camera_position / square_size;
	cam_zoom_over_s_size = camera_zoom * square_size;
}

void fragment() {
	vec2 centered_uv = SCREEN_UV - 0.5;
	vec2 screen_centered = centered_uv * viewport_size;
	vec2 grid_uv = fract(screen_centered / cam_zoom_over_s_size + world_offset);
	
	
	vec2 falloff = fwidth(grid_uv);
	vec2 line_smooth = smoothstep(thickness + falloff, vec2(thickness), grid_uv);
    float mask = max(line_smooth.x, line_smooth.y);
	
	COLOR = vec4(mix(background_col, grid_col, mask), 1.0);
}