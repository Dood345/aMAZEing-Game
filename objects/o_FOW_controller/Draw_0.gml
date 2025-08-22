/// @description Draw Event
if (!o_maze_controller.player_spawned) return;
if (!surface_exists(fog_surface)) {
	fog_surface = surface_create(fog_surface_width, fog_surface_height);
    
	// Fill with black
	surface_set_target(fog_surface);
	draw_clear(c_black);
	draw_surface(fog_surface, fog_draw_x, fog_draw_y);
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


draw_surface(fog_surface, fog_draw_x, fog_draw_y);