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
    
}

else {
    // --- STATE 2: ACTIVE / PLAYING ---
    // This is our normal movement code. It will only run AFTER we have spawned.
    
    // Get Keyboard Input
    var _key_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
    var _key_left = keyboard_check(vk_left) || keyboard_check(ord("A"));
    var _key_down = keyboard_check(vk_down) || keyboard_check(ord("S"));
    var _key_up = keyboard_check(vk_up) || keyboard_check(ord("W"));

    var _move_horizontal = _key_right - _key_left;
    var _move_vertical = _key_down - _key_up;

    var _move_x = _move_horizontal * move_speed;
    var _move_y = _move_vertical * move_speed;

    // Horizontal Collision
    if (place_meeting(x + _move_x, y, o_wall_parent)) {
        while (!place_meeting(x + sign(_move_x), y, o_wall_parent)) {
            x += sign(_move_x);
        }
        _move_x = 0;
    }
    x += _move_x;

    // Vertical Collision
    if (place_meeting(x, y + _move_y, o_wall_parent)) {
        while (!place_meeting(x, y + sign(_move_y), o_wall_parent)) {
            y += sign(_move_y);
        }
        _move_y = 0;
    }
    y += _move_y;
}