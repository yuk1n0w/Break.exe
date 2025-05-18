shader_type canvas_item;

uniform vec4 base_color : source_color = vec4(0.125, 0.188, 0.125, 1.0); // Dark green like #203020
uniform float scanline_intensity : hint_range(0.0, 0.2) = 0.05;
uniform float scanline_frequency : hint_range(1.0, 1000.0) = 300.0; // Adjust based on your 480p height
uniform float noise_intensity : hint_range(0.0, 0.1) = 0.02;
uniform float time_scale : hint_range(0.0, 10.0) = 1.0;

void fragment() {
    vec2 uv = SCREEN_UV; // Use SCREEN_UV for full-screen effect

    // Base color
    vec4 color = base_color;

    // Scanlines
    float scanline = sin(uv.y * scanline_frequency + TIME * 0.1 * time_scale) * 0.5 + 0.5; // Slow scroll
    color.rgb -= scanline * scanline_intensity;

    // Noise
    float noise = (fract(sin(dot(uv + vec2(TIME * 0.01 * time_scale, TIME * 0.02 * time_scale), vec2(12.9898, 78.233))) * 43758.5453) - 0.5) * 2.0;
    color.rgb += noise * noise_intensity;

    // Clamp colors
    color.rgb = clamp(color.rgb, 0.0, 1.0);

    COLOR = color;
}