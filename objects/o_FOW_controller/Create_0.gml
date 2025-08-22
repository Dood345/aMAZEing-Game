/// @description Create Event to init fog of war
// Initialize fog surface
fog_surface = -1;
fog_surface_width = room_width;
fog_surface_height = room_height;

// Ripple effect variables
ripple_time = 0;
ripple_speed = 2.0;
ripple_frequency = 10.0;
ripple_amplitude = 0.02;

// Clear radius when player moves
clear_radius = 64;

// Initialize surface
if (!surface_exists(fog_surface)) {
    fog_surface = surface_create(fog_surface_width, fog_surface_height);
    
    // Fill with black (fog)
    surface_set_target(fog_surface);
    draw_clear(c_black);
    surface_reset_target();
}

/// clear_fog_at(x, y, radius)
function clear_fog_at(xx, yy, radius) {
    if (!surface_exists(fog_surface)) return;
    
    surface_set_target(fog_surface);
    
    // Use additive blending to "erase" the fog
    gpu_set_blendmode(bm_normal);
    draw_set_color(c_white);
    draw_set_alpha(0.3); // Gradual clearing
    draw_circle(xx, yy, radius, false);
    draw_set_alpha(1.0);
    gpu_set_blendmode(bm_normal);
    
    surface_reset_target();
}

/// clear_fog_explosion(x, y, max_radius, duration)
function clear_fog_explosion(xx, yy, max_radius, duration) {
    // Create expanding clear effect
    var current_radius = (current_time % duration) / duration * max_radius;
    clear_fog_at(xx, yy, current_radius);
}