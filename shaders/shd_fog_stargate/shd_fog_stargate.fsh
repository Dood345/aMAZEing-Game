varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float u_time;
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
    
    // Create multiple ripple centers for a more dynamic effect
    vec2 center1 = u_surface_size * 0.3;
    vec2 center2 = u_surface_size * 0.7;
    vec2 center3 = u_surface_size * vec2(0.2, 0.8);
    vec2 center4 = u_surface_size * vec2(0.8, 0.2);
    
    // Multiple overlapping ripples at different frequencies
    float ripples = 0.0;
    ripples += wave(world_pos, center1, 0.08, 2.0, 0.2);
    ripples += wave(world_pos, center2, 0.1, 2.5, 0.15);
    ripples += wave(world_pos, center3, 0.12, 3.0, 0.18);
    ripples += wave(world_pos, center4, 0.09, 1.8, 0.22);
    
    // Add global noise pattern for organic feel
    float noise = sin(world_pos.x * 0.015 + u_time * 0.8) * cos(world_pos.y * 0.02 + u_time * 1.1);
    ripples += noise * 0.15;
    
    // Apply ripples to the fog
    float alpha_mod = 1.0 + ripples * u_ripple_intensity;
    base_color.a *= alpha_mod;
    
    // Add dynamic color variation
    base_color.rgb += vec3(0.05, 0.15, 0.3) * ripples * 0.6;
    
    gl_FragColor = base_color * v_vColour;
}