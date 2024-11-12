shader_type canvas_item;
uniform float speed = .05;
uniform sampler2D SCREEN_TEXTURE:hint_screen_texture;
uniform float intensity : hint_range(0,1) = 1.0;
void vertex() {
	UV.x += TIME * speed;
	UV.y += TIME * speed;
}


