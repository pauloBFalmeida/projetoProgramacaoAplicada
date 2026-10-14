shader_type canvas_item;

// Corner radius in pixels. Set to 0 to disable that side's corners.
uniform float radius_top : hint_range(0.0, 256.0, 0.5) = 16.0;
uniform float radius_bottom : hint_range(0.0, 256.0, 0.5) = 16.0;

void fragment() {
	// ColorRect has no texture, so recover its pixel size from the UV derivatives
	vec2 size = 1.0 / fwidth(UV);
	vec2 half_size = size * 0.5;

	// Position relative to the center of the rect (y grows downward)
	vec2 p = (UV - 0.5) * size;

	// Upper half uses the top radius, lower half uses the bottom radius
	float r = p.y < 0.0 ? radius_top : radius_bottom;

	// Clamp so the radius can never exceed half of the shortest side
	r = min(r, min(half_size.x, half_size.y));

	// Signed distance to a rounded box (negative = inside)
	vec2 q = abs(p) - half_size + r;
	float dist = length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - r;

	// 1px anti-aliased edge, and only the alpha is touched
	COLOR.a *= 1.0 - smoothstep(-1.0, 0.0, dist);
}