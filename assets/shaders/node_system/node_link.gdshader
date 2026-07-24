shader_type canvas_item;


uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
uniform sampler2D noise_texture;
uniform sampler2D gradient_texture;

uniform vec4 color : source_color;

uniform float distortion : hint_range(0.0, 0.3, 0.005) = 0.03;
uniform float noise_speed_x : hint_range(-10.0, 10.0, 0.01) = 1.0;

void fragment() {
    vec2 noise_uv = UV + vec2(TIME * noise_speed_x, 0.0);
    noise_uv = fract(noise_uv);
	
    vec4 noiseValue = texture(noise_texture, noise_uv);
    vec2 noiseDistortion = (noiseValue.rg * distortion);
    
    vec2 animated_uv = UV + noiseDistortion;
    
    COLOR = texture(gradient_texture, animated_uv);
    
    float grey = 1.0 - (0.2126 * COLOR.r + 0.7152 * COLOR.g + 0.0722 * COLOR.b);
    if (grey < 0.9) {
        COLOR.a *= pow(grey, 2);
    }

    if (grey < 0.5) {
        discard;
    }
    COLOR.rgb = vec3(color.rgb);
} 
