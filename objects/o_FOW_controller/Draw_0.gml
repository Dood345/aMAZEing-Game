/// @description Draw Event
if (!o_maze_controller.player_spawned) return;
if (!surface_exists(fog_surface)) {
	fog_surface = surface_create(fog_surface_width, fog_surface_height);
    
	// Fill with blue
	surface_set_target(fog_surface);
	draw_clear(fog_color);
	surface_reset_target();
}

// Draw the fog - this should darken unexplored areas
surface_set_target(fog_surface);
    
// Draw white circles to keep areas revealed
gpu_set_blendmode(bm_subtract);
draw_set_color(c_white);
draw_set_alpha(0.7);
draw_circle(o_player.x - fog_draw_x, o_player.y - fog_draw_y, clear_radius, false);
draw_set_alpha(1.0);
gpu_set_blendmode(bm_normal);
    
surface_reset_target();

ripple_time += ripple_speed * (1/60);

if stargate_mode {
	shader_set(shd_fog_stargate);

	// Pass the required uniform variables
	shader_set_uniform_f(shader_get_uniform(shd_fog_stargate, "u_time"), ripple_time);
	shader_set_uniform_f(shader_get_uniform(shd_fog_stargate, "u_player_pos"), 
	    o_player.x - fog_draw_x, o_player.y - fog_draw_y);
	shader_set_uniform_f(shader_get_uniform(shd_fog_stargate, "u_surface_size"), 
	    fog_surface_width, fog_surface_height);
	shader_set_uniform_f(shader_get_uniform(shd_fog_stargate, "u_ripple_intensity"), 
	    ripple_intensity);
} 
else {
	// NOW draw the surface to the screen with shader applied
	shader_set(shd_fog_basic);

	// Update time for animation
	shader_set_uniform_f(shader_get_uniform(shd_fog_basic, "u_time"), ripple_time);
}

draw_surface(fog_surface, fog_draw_x, fog_draw_y);
shader_reset();