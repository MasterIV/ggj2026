shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 1.0;
uniform float rotation : hint_range(0.0, 6.28318) = 0.0;
uniform float tilt_x : hint_range(-1.57, 1.57) = 0.6;  // Tilt around X axis

void fragment() {
	// Center UVs
	vec2 uv = UV - vec2(0.5);

	// First rotate in 2D
	float cos_rot = cos(rotation);
	float sin_rot = sin(rotation);
	vec2 rotated = vec2(
	uv.x * cos_rot - uv.y * sin_rot,
	uv.x * sin_rot + uv.y * cos_rot
	);

	// Apply 3D perspective tilt
	float distance = 2.0;  // Camera distance
	float cos_tilt = cos(tilt_x);
	float sin_tilt = sin(tilt_x);

	// Transform to 3D, apply rotation, project back
	float z = distance;
	float y3d = rotated.y * cos_tilt;
	float z3d = rotated.y * sin_tilt + z;

	// Perspective divide
	vec2 projected = vec2(rotated.x, y3d) / (z3d / distance);

	// Scale to keep similar size
	projected *= 0.7;

	// Back to texture space
	vec2 final_uv = projected + vec2(0.5);

	// Discard pixels outside bounds
	if (final_uv.x < 0.0 || final_uv.x > 1.0 || final_uv.y < 0.0 || final_uv.y > 1.0) {
		COLOR = vec4(0.0);
		return;
	}

	vec4 tex = texture(TEXTURE, final_uv);

	// Cooldown effect on original UV
	vec2 angle_uv = UV - vec2(0.5);
	float angle = atan(angle_uv.x, -angle_uv.y);
	float normalized_angle = (angle + PI) / (2.0 * PI);
	float fill_threshold = 1.0 - progress;

	vec4 color;
	if (normalized_angle <= fill_threshold) {
		float gray = dot(tex.rgb, vec3(0.299, 0.587, 0.114));
		color = vec4(gray, gray, gray, tex.a);
	} else {
		color = tex;
	}

	COLOR = color;
}
