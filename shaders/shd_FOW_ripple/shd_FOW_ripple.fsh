//
// FOW fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_time;
uniform float u_frequency;
uniform float u_amplitude;
uniform sampler2D u_fog_texture;

void main() {
    vec2 texCoord = v_vTexcoord;
    
    // Sample the fog texture
    vec4 fogColor = texture2D(u_fog_texture, texCoord);
    
    // Create ripple effect at fog edges
    vec2 center = vec2(0.5, 0.5);
    float distance_from_center = length(texCoord - center);
    
    // Create multiple ripple rings
    float ripple1 = sin((distance_from_center * u_frequency) - (u_time * 2.0)) * u_amplitude;
    float ripple2 = sin((distance_from_center * u_frequency * 1.5) - (u_time * 3.0)) * u_amplitude * 0.5;
    float ripple3 = sin((distance_from_center * u_frequency * 2.0) - (u_time * 4.0)) * u_amplitude * 0.3;
    
    vec2 rippleOffset = vec2(ripple1 + ripple2 + ripple3) * 0.1;
    
    // Sample with ripple distortion only where there's fog edge
    vec4 distortedFog = texture2D(u_fog_texture, texCoord + rippleOffset);
    
    // Create edge detection for ripple effect
    float fogEdge = length(fogColor.rgb - texture2D(u_fog_texture, texCoord + vec2(0.01, 0.0)).rgb) +
                   length(fogColor.rgb - texture2D(u_fog_texture, texCoord + vec2(0.0, 0.01)).rgb);
    
    // Apply ripple only at edges
    vec4 finalFog = mix(fogColor, distortedFog, fogEdge * 10.0);
    
    // Add some shimmer effect
    float shimmer = sin(u_time * 5.0 + distance_from_center * 20.0) * 0.1 + 0.9;
    finalFog.rgb *= shimmer;
    
    gl_FragColor = finalFog * v_vColour;
}