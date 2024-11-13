shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec2 global_position;
uniform vec2 screen_size;
uniform float force : hint_range(0.0, 10.0);
uniform float size : hint_range(0.0, 1.0);
uniform float thickness : hint_range(0.0, 0.5);

void fragment() {
    // Convert global_position to screen space in a way compatible with Godot 4.3
    vec2 center = global_position / screen_size;
    center.y = 1.0 - center.y;

    // Adjust UV coordinates for aspect ratio
    float ratio = screen_size.x / screen_size.y;
    vec2 scaledUV = (FRAGCOORD.xy / screen_size - vec2(0.5, 0.0)) / vec2(ratio, 1.0) + vec2(0.5, 0.0);

    // Mask for circular area
    float dist = length(scaledUV - center);
    float mask = (1.0 - smoothstep(size - 0.1, size, dist)) * smoothstep(size - thickness - 0.1, size - thickness, dist);

    // Displacement calculation
    vec2 disp = normalize(scaledUV - center) * force * mask;
    vec2 displaced_uv = FRAGCOORD.xy / screen_size - disp;

    // Sample the screen texture with displacement
    COLOR = texture(SCREEN_TEXTURE, displaced_uv);
}