shader_type canvas_item;


uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
uniform sampler2D gradient_texture_inactive;

uniform vec4 color_inactive : source_color;


void fragment() {

    
    // Apply the distortion to the UV coordinates of the gradient texture
    vec2 animated_uv = UV;
    
    // Sample the gradient texture with the distorted UV coordinates
    COLOR = texture(gradient_texture_inactive, UV);
    
    // Apply alpha blending based on color intensity
    float grey = 1.0 - (0.2126 * COLOR.r + 0.7152 * COLOR.g + 0.0722 * COLOR.b);
    if (grey < 0.9) {
        COLOR.a *= pow(grey, 2);
    }
    
    // Ensure some areas are transparent
    if (grey < 0.5) {
        discard;
    }
    
    // Set the final color
    COLOR.rgb = vec3(color_inactive.rgb);
} 
