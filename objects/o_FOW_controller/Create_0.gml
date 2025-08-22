	/// @description Create Event to init fog of war
if (instance_exists(o_maze_controller)) {
	// Initialize fog surface
	fog_surface = -1;
	fog_surface_width = o_maze_controller.MAZE_WIDTH * o_maze_controller.CELL_SIZE;
	fog_surface_height = o_maze_controller.MAZE_HEIGHT * o_maze_controller.CELL_SIZE;
	fog_draw_x = room_width/2 - fog_surface_width/2;
	fog_draw_y = room_height/2 - fog_surface_height/2;

	// Ripple effect variables
	ripple_time = 0;
	ripple_speed = 2.0;
	ripple_frequency = 10.0;
	ripple_amplitude = 0.02;

	// Clear radius when player moves
	clear_radius = 64;
	
	// Initialize surface - start with Fill with black
	if (!surface_exists(fog_surface)) {
	    fog_surface = surface_create(fog_surface_width, fog_surface_height);
    
	    // Fill with black
	    surface_set_target(fog_surface);
	    draw_clear(c_black);
	    surface_reset_target();
	}

	/// clear_fog_explosion(x, y, max_radius, duration)
	function clear_fog_explosion(xx, yy, max_radius, duration) {
	    // Create expanding clear effect
	    var current_radius = (current_time % duration) / duration * max_radius;
	    clear_fog_at(xx, yy, current_radius);
	}
}