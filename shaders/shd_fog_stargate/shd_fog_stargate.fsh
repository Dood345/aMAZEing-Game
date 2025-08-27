varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_time;
uniform vec2 u_player_pos;
uniform vec2 u_surface_size;
uniform float u_ripple_intensity;

// Multiple wave functions for complex ripples
float wave(vec2 pos, vec2 center, float freq, float phase, float amplitude) {
    float dist = distance(pos, center);
    return amplitude * sin(dist * freq - u_time * phase);
}

void main() {
    vec4 base_color = texture2D(gm_BaseTexture, v_vTexcoord);
    
    // Convert to world coordinates
    vec2 world_pos = v_vTexcoord * u_surface_size;
    vec2 player_center = u_player_pos;
    
    // Multiple overlapping ripples at different frequencies
    float ripples = 0.0;
    ripples += wave(world_pos, player_center, 0.1, 3.0, 0.3);
    ripples += wave(world_pos, player_center, 0.15, 2.5, 0.2);
    ripples += wave(world_pos, player_center, 0.08, 4.0, 0.4);
    ripples += wave(world_pos, player_center, 0.12, 3.5, 0.25);
    
    // Add some noise for organic feel
    float noise = sin(world_pos.x * 0.02 + u_time) * cos(world_pos.y * 0.03 + u_time * 1.2);
    ripples += noise * 0.1;
    
    // Apply ripples to the fog
    float alpha_mod = 1.0 + ripples * u_ripple_intensity;
    base_color.a *= alpha_mod;
    
    // Optional: Add slight blue tint like Stargate
    base_color.rgb += vec3(0.1, 0.2, 0.4) * ripples * 0.5;
    
    gl_FragColor = base_color * v_vColour;
}