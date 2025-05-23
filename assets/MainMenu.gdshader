shader_type canvas_item;

uniform float scanline_intensity : hint_range(0.0, 0.2) = 0.05;
uniform float scanline_frequency : hint_range(1.0, 1000.0) = 300.0; // Adjust based on your resolution
uniform float noise_intensity : hint_range(0.0, 0.1) = 0.02;
uniform float time_scale : hint_range(0.0, 10.0) = 1.0;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

void fragment() {
    // Sample the current screen texture (the image below)
    vec4 base = texture(SCREEN_TEXTURE, SCREEN_UV);

    // Create scanlines.
    // "uv.y" is multiplied by scanline_frequency to define the density/frequency of the scanlines.
    // TIME is used to add a slow vertical scroll if desired.
    float scanline = sin(SCREEN_UV.y * scanline_frequency + TIME * 0.1 * time_scale) * 0.5 + 0.5;

    // Subtract the scanline effect from the base image.
    base.rgb -= scanline * scanline_intensity;

    // Create noise.
    // This generates a random value based on uv coordinates and time.
    float noise = fract(sin(dot(SCREEN_UV + vec2(TIME * 0.01 * time_scale, TIME * 0.02 * time_scale),
                                  vec2(12.9898, 78.233))) * 43758.5453);
    noise = (noise - 0.5) * 2.0; // Normalize noise to range [-1, 1]
    base.rgb += noise * noise_intensity;

    // Clamp the resulting colors to ensure they stay within [0, 1]
    base.rgb = clamp(base.rgb, 0.0, 1.0);

    COLOR = base;
}
