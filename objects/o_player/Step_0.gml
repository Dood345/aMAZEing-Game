/// @description Player Spawning and Movement Logic

if (!has_spawned) {
    // --- STATE 1: WAITING TO SPAWN ---
    // We will stay in this state until the maze is fully generated.
    
    // Check if the generator exists AND if its 'generation_complete' flag is true
    if (instance_exists(o_maze_generator) && o_maze_generator.generation_complete) {
        
        // The maze is ready! Time to spawn.
        // This is the code we moved from the Create event.
        
        // Find the closest maze cell to our starting position in the room editor
        var _grid_x = floor((x - o_maze_generator.offset_x) / o_maze_generator.CELL_SIZE);
        var _grid_y = floor((y - o_maze_generator.offset_y) / o_maze_generator.CELL_SIZE);
        
        _grid_x = clamp(_grid_x, 0, o_maze_generator.MAZE_WIDTH - 1);
        _grid_y = clamp(_grid_y, 0, o_maze_generator.MAZE_HEIGHT - 1);
        
        // Tell the generator where its official start point is
        o_maze_generator.start_cell_x = _grid_x;
        o_maze_generator.start_cell_y = _grid_y;
        
        // Calculate the exact pixel center of that starting cell
        var _target_x = (o_maze_generator.offset_x) + (_grid_x * o_maze_generator.CELL_SIZE);
        var _target_y = (o_maze_generator.offset_y) + (_grid_y * o_maze_generator.CELL_SIZE);
        
        // Snap the player's position to that target
        x = _target_x;
        y = _target_y;

		// Snap the player's position to that target
		x = _target_x;
		y = _target_y;

		// Make the player visible
		visible = true;

		// Get a reference to the generator's live particle system
		var _ps = o_maze_generator.spawn_ps_instance;

		// Create 20 particles of the FIRST particle type (index 0) from our asset
		// at the player's current (x, y) position.
		part_particles_create(_ps, x, y, 0, 20);
		visible = true;
        has_spawned = true;
    }
} else {
    // --- STATE 2: ACTIVE / PLAYING ---
    // This is our normal movement code. It will only run AFTER we have spawned.
    // Check if we are at the end goal
	if (instance_exists(o_maze_generator)) {
	    // Get the grid coordinates of our current position
	    var _current_grid_x = floor((x - o_maze_generator.offset_x) / o_maze_generator.CELL_SIZE);
	    var _current_grid_y = floor((y - o_maze_generator.offset_y) / o_maze_generator.CELL_SIZE);
    
	    // Is our current cell the same as the generator's end cell?
	    if (_current_grid_x == o_maze_generator.end_cell_x && _current_grid_y == o_maze_generator.end_cell_y) {
        
	        // --- GOAL REACHED! ---
        
	        // 1. Tell the generator to reset
	        o_maze_generator.reset_maze();
        
	        // 2. Become invisible again
	        visible = false;
			
	        // 3. Reset our own state to "waiting"
	        has_spawned = false;
        
	        // 4. (Optional) Move ourselves back to the center of the room to be ready for the next spawn
	        x = room_width / 2;
	        y = room_height / 2;
			h_speed = 0; // Reset momentum too!
			v_speed = 0;
	    }
	}
	
	// --- NEW, EVEN MORE GENERIC Power-Up Collection ---
	var _pickup = instance_place(x, y, o_pickup_parent);
	if (_pickup != noone) {
    
	    var _data = _pickup.item_data;
    
	    // Run the function that is stored inside the item's data!
	    // We pass 'id' which is a reference to ourself (the player instance).
	    _data.apply_effect(id); 
    
	    instance_destroy(_pickup);
	}
	
	// --- Handle Temporary Power-Up Effects ---
	if (current_speedboost_durration > 0) {
        current_speedboost_durration -= 1;
        
        // If the timer JUST ran out...
        if (current_speedboost_durration <= 0) {
            recalculate_stats(); // ...update our stats to remove the buff.
        }
    }
	
    // --- 1. Get Input and Apply Acceleration ---
	var _key_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
	var _key_left = keyboard_check(vk_left) || keyboard_check(ord("A"));
	var _key_down = keyboard_check(vk_down) || keyboard_check(ord("S"));
	var _key_up = keyboard_check(vk_up) || keyboard_check(ord("W"));

	var _move_horizontal = _key_right - _key_left;
	var _move_vertical = _key_down - _key_up;

	h_speed += _move_horizontal * current_acceleration;
	v_speed += _move_vertical * current_acceleration;


	// --- 2. Apply Friction if No Input ---
	if (_move_horizontal == 0) {
	    if (abs(h_speed) > current_stop_threshold) {
	        h_speed -= sign(h_speed) * current_friction_amount; // Slow down
	    } else {
	        h_speed = 0; // Stop completely
	    }
	}
	if (_move_vertical == 0) {
	    if (abs(v_speed) > current_stop_threshold) {
	        v_speed -= sign(v_speed) * current_friction_amount; // Slow down
	    } else {
	        v_speed = 0; // Stop completely
	    }
	}


	// --- 3. Clamp to Max Speed ---
	h_speed = clamp(h_speed, -current_max_speed, current_max_speed);
	v_speed = clamp(v_speed, -current_max_speed, current_max_speed);


	// --- 4. Handle Collisions ---
	var _move_x = h_speed;
	var _move_y = v_speed;

	// Horizontal Collision
	if (place_meeting(x + _move_x, y, o_wall_parent)) {
	    while (!place_meeting(x + sign(_move_x), y, o_wall_parent)) {
	        x += sign(_move_x);
	    }
	    h_speed = 0; // Hit a wall, stop horizontal momentum
	    _move_x = 0;
	}
	x += _move_x;

	// Vertical Collision
	if (place_meeting(x, y + _move_y, o_wall_parent)) {
	    while (!place_meeting(x, y + sign(_move_y), o_wall_parent)) {
	        y += sign(_move_y);
	    }
	    v_speed = 0; // Hit a wall, stop vertical momentum
	    _move_y = 0;
	}
	y += _move_y;
}