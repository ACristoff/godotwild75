shader_type canvas_item;

#define iTime TIME
#define fragColor COLOR
#define iResolution 1.0/SCREEN_PIXEL_SIZE

uniform vec2 glow = vec2(1.0);
uniform sampler2D iChannel0 ;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable ;

uniform float HDR_CURVE : hint_range(0.0, 10.0, 0.1) = 4.0;

uniform vec2 BG_SPEED = vec2( -0.03, 0.05);
uniform vec2 FG_SPEED = vec2( 0.0, -0.02);

vec3 make_hdr(vec3 col) {
    col = pow(col, vec3(HDR_CURVE));
    return col;
}

#define SAMPLES 12

#define ANGLE_SAMPLES (3 * SAMPLES)
#define OFFSET_SAMPLES (1 * SAMPLES)


float degs2rads(float degrees) {
    return degrees * 0.01745329251994329576923690768489;
}

vec2 rot2D(float offset, float angle) {
    angle = degs2rads(angle);
    return vec2(cos(angle) * offset, sin(angle) * offset);
}

vec3 circle_blur(sampler2D sp, vec2 uv, vec2 scale, vec2 iRes) {
    vec2 ps = (1.0 / iRes.xy) * scale;
    vec3 col = vec3(0.0);
    float accum = 0.0;
    
    for (int a = 0; a < 360; a += 360 / ANGLE_SAMPLES) {
        for (int o = 0; o < OFFSET_SAMPLES; ++o) {
			col += texture(sp, uv + ps * rot2D(float(o), float(a))).rgb * (float(o * o) + 1.5);
            accum += float(o * o);
        }
    }
    
    return col / accum;
}

vec3 pseudo_tonemap(vec3 col, float exposure) {
    col = pow(col, vec3(1.0 / HDR_CURVE));
    return col;
	}

void fragment() {
	//use in Subviewport-ColorRect-Material-ShaderMaterial-shader
	vec2 uv = SCREEN_UV;
	//uv.y = 1.0 - uv.y;
    //vec2 uv_bg = fract(uv + iTime * BG_SPEED);
    //vec2 uv_fg = fract((1.0 - uv) + iTime * FG_SPEED);
    //
    //vec3 bg = texture(iChannel0, uv_bg).rgb;
    //vec3 fg = texture(iChannel0, uv_fg).rgb;
    //
    //vec3 col = pow((bg + fg), vec3(0.5));
    //col = col * col;
    //col = make_hdr(col);
    //
    //fragColor = vec4(col, 1.0);
    
	//save as another shader, and use in TextureRect-Material-ShaderMetirial-shader,the TextureRect's Texture is set to ViewportTexture,and choose the above Subviewport
    vec3 col2 = circle_blur(TEXTURE, uv, glow, iResolution);
    col2 = pseudo_tonemap(col2, 1.0);
    fragColor = vec4(col2, 1.0);
}