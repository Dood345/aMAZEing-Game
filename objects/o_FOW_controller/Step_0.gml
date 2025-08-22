/// @description step event to clear fog around player
// Update ripple animation
ripple_time += ripple_speed / 60;

// Recreate surface if it doesn't exist
if (!surface_exists(fog_surface)) {
    fog_surface = surface_create(fog_surface_width, fog_surface_height);
    surface_set_target(fog_surface);
    draw_clear(c_black);
    surface_reset_target();
}

// Clear fog around player
//if (instance_exists(o_player) && current_time % 3 == 0) {
if (instance_exists(o_player)) {
    clear_fog_at(o_player.x, o_player.y, clear_radius);
}