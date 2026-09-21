shader_type canvas_item;

const vec2 center = vec2(540.0,700.0);
const float rad = 450.0;
const float line_spacing = 60.0;
const float line_thickness = 10.0;
const float pixel_size = 4.0;
const float turn_speed = 20.0;

float curve(float x) {
	return sqrt(1.0 - pow(x,2.0));
}

bool on_longitude(float dist_to_center) {
	float dist_proportional = dist_to_center / rad;
	return abs(mod(dist_to_center - TIME * turn_speed,line_spacing)) < line_thickness * curve(dist_proportional);
}

bool on_latitude(vec2 local_pos) {
	float bend = curve(local_pos.y / rad);
	return mod(abs(local_pos.x) / bend,line_spacing) < line_thickness;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 pos = vec2(FRAGCOORD.r,FRAGCOORD.g);
	vec2 pixelated_pos = round(pos/pixel_size) * pixel_size;
	vec2 local_pos = pixelated_pos - center;
	float dist_to_center = length(local_pos);
	if(dist_to_center < rad) {
		if(on_longitude(dist_to_center) || on_latitude(local_pos)) {
			COLOR = vec4(0.6,0.0,0.0,1.0);
		}
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
