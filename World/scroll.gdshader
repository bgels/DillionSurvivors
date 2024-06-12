shader_type canvas_item;

uniform float speed = .1;
void vertex() {
	// Called for every vertex the material is visible on.
	UV.x += TIME * .1;
}

