/// @description Perform one step of maze generation.

if (!generation_complete) {
    // --- STATE 1: GENERATING THE MAZE ---
    // (This is the original maze generation logic, it is unchanged)
    // If the stack is empty, we are done!
    if (ds_stack_empty(path_stack)) {
        generation_complete = true;
        exit; // Exit for this frame, we'll build walls on the next frame
    }

    var _current_cell = ds_stack_top(path_stack);
    var _neighbors = get_unvisited_neighbors(_current_cell.x, _current_cell.y);

    if (array_length(_neighbors) > 0) {
        var _next_cell = _neighbors[irandom(array_length(_neighbors) - 1)];
        ds_stack_push(path_stack, _next_cell);
        remove_wall_between(_current_cell, _next_cell);
        _next_cell.visited = true;
    } else {
        end_cell_x = _current_cell.x;
        end_cell_y = _current_cell.y;
        ds_stack_pop(path_stack);
    }
    
} else if (!walls_built) {
    // --- STATE 2: BUILDING THE WALLS (runs only once) ---
    // Loop through every cell to place the walls
    var _layer_id = layer_get_id("Instances_Walls");
    
    // --- Create Internal and Top/Left Walls ---
    // Each cell only creates the walls above and to its left.
    for (var i = 0; i < MAZE_WIDTH; i++) {
        for (var j = 0; j < MAZE_HEIGHT; j++) {
            var _cell = grid[i][j];
            var _x_pos = (i * CELL_SIZE) + offset_x;
            var _y_pos = (j * CELL_SIZE) + offset_y;
            
            if (_cell.wall_north) {
                instance_create_layer(_x_pos, _y_pos, _layer_id, o_wall_h);
            }
            if (_cell.wall_west) {
                instance_create_layer(_x_pos, _y_pos, _layer_id, o_wall_v);
            }
        }
    }
    
    // --- Create Final Outer Walls ---
    // We need to manually add the final right and bottom edges of the maze.
    var _maze_pixel_w = MAZE_WIDTH * CELL_SIZE;
    var _maze_pixel_h = MAZE_HEIGHT * CELL_SIZE;
    
    // Add the bottom border
    for (var i = 0; i < MAZE_WIDTH; i++) {
        var _x_pos = (i * CELL_SIZE) + offset_x;
        instance_create_layer(_x_pos, offset_y + _maze_pixel_h, _layer_id, o_wall_h);
    }
    // Add the right border
    for (var j = 0; j < MAZE_HEIGHT; j++) {
        var _y_pos = (j * CELL_SIZE) + offset_y;
        instance_create_layer(offset_x + _maze_pixel_w, _y_pos, _layer_id, o_wall_v);
    }
    
    walls_built = true; // Move to the next state

} else if (!powerup_spawned) {
	// --- STATE 3: SPAWN POWERUP (runs only once) ---
    // Wait until the player exists AND has confirmed its own spawn
    if (instance_exists(o_player) && o_player.has_spawned) {
        
        // Find all cells that are 20 steps away from the player's start
        var _spawn_points = find_locations_by_distance(start_cell_x, start_cell_y, 20);
        
        // Check if we actually found any valid spots
        if (array_length(_spawn_points) > 0) {
            
            // Pick one of the valid spots at random
            var _chosen_point = _spawn_points[irandom(array_length(_spawn_points) - 1)];
            var _spawn_grid_x = _chosen_point[0];
            var _spawn_grid_y = _chosen_point[1];
            
            // Calculate the pixel position (centered in the cell)
            var _pixel_x = (offset_x) + (_spawn_grid_x * CELL_SIZE);
            var _pixel_y = (offset_y) + (_spawn_grid_y * CELL_SIZE);
            
            // Create the pickup!
            instance_create_layer(_pixel_x, _pixel_y, "Instances_Player", o_speedup_pickup);
			randomize()
			// Pick one of the valid spots at random
            _chosen_point = _spawn_points[irandom(array_length(_spawn_points) - 1)];
            _spawn_grid_x = _chosen_point[0];
            _spawn_grid_y = _chosen_point[1];
            
            // Calculate the pixel position (centered in the cell)
            _pixel_x = (offset_x) + (_spawn_grid_x * CELL_SIZE);
            _pixel_y = (offset_y) + (_spawn_grid_y * CELL_SIZE);
            
            // Create the pickup!
            instance_create_layer(_pixel_x, _pixel_y, "Instances_Player", o_fist_pickup);
        }
        else {
            // Optional: If no spots were found 20 steps away, you could try a shorter distance
            // or just not spawn a power-up for this maze.
            show_debug_message("Could not find a valid spawn point at 20 steps!");
        }
        
        // Mark spawning as complete, whether it succeeded or not
        powerup_spawned = true;
    }
}