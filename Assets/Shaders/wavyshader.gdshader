shader_type canvas_item;

// Animate from 0 to 1, result in 0 should be the same as in 1, a loop
uniform float progress: hint_range(0.0, 1.5) = 0.0;

// How jagged each band of melting pixels are
// This is also the amplitude of the wave
uniform float meltness: hint_range(0.0, 5.0) = 1.0;

// If it should affect only lower parts of the shader, it also increases the meltness
uniform float how_low: hint_range(0.0, 10.0) = 1.0;

// How wavy. 
uniform float wave_frequency: hint_range(0.0, 30.0) = 20.0;

float wave(float x) {
	return x - 2.5 + cos(2.0 * PI * progress + wave_frequency * x);
}

void fragment() {
	vec2 uv = UV;
	
	uv.x -= pow( uv.x,how_low ) * 0.02 * meltness * wave( UV.y - mod( UV.y, TEXTURE_PIXEL_SIZE.y ));
	
	COLOR = texture(TEXTURE, uv);
	
	// "delete" pixels out of range
	if (uv.x <= 0.0 || uv.x >= 1.0) {
		COLOR.a = 0.0;
	}
}
