if (in_maze) {
	/// @description Player states and Movement Logic
	
	// --- STATE 1: ACTIVE / PLAYING ---
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
	if (current_speedboost_duration > 0) {
		current_speedboost_duration -= 1;
		
		// If the timer JUST ran out...
		if (current_speedboost_duration <= 0) {
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
	} else {
		last_move_h = _move_horizontal;
		last_move_v = 0;
	}
	if (_move_vertical == 0) {
		if (abs(v_speed) > current_stop_threshold) {
			v_speed -= sign(v_speed) * current_friction_amount; // Slow down
		} else {
			v_speed = 0; // Stop completely
		}
	} else { 
		last_move_h = 0;
		last_move_v = _move_vertical;
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