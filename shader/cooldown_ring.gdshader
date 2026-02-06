shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 1.0;  // 0 = full cooldown, 1 = ready
uniform vec4 ready_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);  // Red when ready
uniform vec4 cooldown_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);  // White when cooling down

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	
	// Calculate angle from center (0 = top, goes clockwise)
	vec2 centered_uv = UV - vec2(0.5);
	float angle = atan(centered_uv.x, -centered_uv.y);  // Radians from -PI to PI
	float normalized_angle = (angle + PI) / (2.0 * PI);  // Normalize to 0-1
	
	// Determine if this pixel should be colored based on progress
	// Start from top and fill clockwise
	float fill_threshold = 1.0 - progress;  // Invert so 0 progress = all colored
	
	vec4 color;
	if (normalized_angle <= fill_threshold) {
		// This part is in cooldown - interpolate toward cooldown color
		color = cooldown_color;
	} else {
		// This part is ready - interpolate toward ready color
		color = ready_color;
	}
	
	// Apply color to the texture (multiply to preserve grayscale details)
	COLOR = tex * color;
}