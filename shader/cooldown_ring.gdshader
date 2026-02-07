shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 1.0;  // 0 = full cooldown, 1 = ready

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	// Calculate angle from center (0 = top, goes clockwise)
	vec2 centered_uv = UV - vec2(0.5);
	float angle = atan(centered_uv.x, -centered_uv.y);  // Radians from -PI to PI
	float normalized_angle = (angle + PI) / (2.0 * PI);  // Normalize to 0-1

	// Determine if this pixel should be colored or grayscale based on progress
	// Start from top and fill clockwise
	float fill_threshold = 1.0 - progress;  // Invert so 0 progress = all grayscale

	vec4 color;
	if (normalized_angle <= fill_threshold) {
		// This part is in cooldown - convert to grayscale
		float gray = dot(tex.rgb, vec3(0.299, 0.587, 0.114));  // Luminance calculation
		color = vec4(gray, gray, gray, tex.a);
	} else {
		// This part is ready - show original color
		color = tex;
	}

	COLOR = color;
}
