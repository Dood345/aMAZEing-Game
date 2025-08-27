varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_time;

void main() {
    vec4 base_color = texture2D(gm_BaseTexture, v_vTexcoord);
    
    // Simple pulsing effect to test functionality
    float pulse = 0.5 + 0.5 * sin(u_time * 2.0);
    base_color.rgb *= pulse;
    
    gl_FragColor = base_color * v_vColour;
}