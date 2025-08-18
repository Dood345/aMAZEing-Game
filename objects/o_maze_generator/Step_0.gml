/// @description Perform one step of maze generation.

if (!generation_complete) {
    // --- STATE 1: GENERATING THE MAZE ---
    // This uses a randomized Depth-First Search (DFS) algorithm, also known as the "recursive backtracker" method.
    // It works by starting at a random cell, pushing it to a stack, and then repeatedly:
    // 1. Look at the cell on top of the stack.
    // 2. Find its unvisited neighbors.
    // 3. If there are any, pick one at random, push it to the stack, and remove the wall between the two cells.
    // 4. If there are none, pop the cell from the stack (backtrack) and repeat from step 1.
    // The process is complete when the stack is empty.

    // If the stack is empty, it means we have backtracked from every path. The maze is fully generated.
    if (ds_stack_empty(path_stack)) {
        generation_complete = true;
        exit; // Exit for this frame, we'll build walls on the next frame
    }

    // Get the current cell we are carving a path from (the top of the stack).
    var _current_cell = ds_stack_top(path_stack);
    // Find all adjacent cells that have not been visited yet.
    var _neighbors = get_unvisited_neighbors(_current_cell.x, _current_cell.y);

    // If there is at least one unvisited neighbor:
    if (array_length(_neighbors) > 0) {
        // Choose a random neighbor to move to next.
        var _next_cell = _neighbors[irandom(array_length(_neighbors) - 1)];
        // Push the new cell to the stack, making it the current one.
        ds_stack_push(path_stack, _next_cell);
        // Knock down the wall between the current cell and the chosen neighbor.
        remove_wall_between(_current_cell, _next_cell);
        // Mark the new cell as visited so we don't create loops.
        _next_cell.visited = true;
    } else {
        // If there are no unvisited neighbors, we've hit a dead end.
        // We'll mark this as a potential end point for the maze.
        end_cell_x = _current_cell.x;
        end_cell_y = _current_cell.y;
        // Backtrack by popping the current cell from the stack to return to the previous one.
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
                instance_create_layer(_x_pos + CELL_SIZE / 2, _y_pos, _layer_id, o_wall_h);
            }
            if (_cell.wall_west) {
                instance_create_layer(_x_pos, _y_pos + CELL_SIZE / 2, _layer_id, o_wall_v);
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
        instance_create_layer(_x_pos + CELL_SIZE / 2, offset_y + _maze_pixel_h, _layer_id, o_wall_h);
    }
    // Add the right border
    for (var j = 0; j < MAZE_HEIGHT; j++) {
        var _y_pos = (j * CELL_SIZE) + offset_y;
        instance_create_layer(offset_x + _maze_pixel_w, _y_pos + CELL_SIZE / 2, _layer_id, o_wall_v);
    }
    
    walls_built = true; // Move to the next state

} else if (!powerup_spawned) {
	// --- STATE 3: SPAWN POWERUPS (runs only once) ---
    // Wait until the player exists AND has confirmed its own spawn
    if (instance_exists(o_player) && o_player.has_spawned) {
        show_debug_message("Generator received start at: (" + string(start_cell_x) + ", " + string(start_cell_y) + ")");
        
        // Find all valid spawn locations within the specified distance range
        var _spawn_locations = find_spawn_locations(start_cell_x, start_cell_y, powerup_min_dist, powerup_max_dist);
        show_debug_message("Found " + string(array_length(_spawn_locations)) + " spawn locations.");
        
        // Shuffle the list of valid locations to randomize placement
        _spawn_locations = array_shuffle(_spawn_locations);
        
        // Only try to spawn if there's at least one valid spot
        if (array_length(_spawn_locations) > 0) {
            show_debug_message("Found " + string(array_length(_spawn_locations)) + " spawn locations.");
            // Loop through the list of power-up types we want to spawn
            for (var i = 0; i < array_length(powerup_types); i++) {

                // Get the index for the spawn location.
                // If we have more powerups than locations, reuse the last location.
                var _location_index = min(i, array_length(_spawn_locations) - 1);
                
                // Get the current power-up type and a spawn point
                var _powerup_obj = powerup_types[i];
				show_debug_message("Attempting to spawn: " + object_get_name(_powerup_obj));
                var _spawn_point = _spawn_locations[_location_index];
                var _spawn_grid_x = _spawn_point[0];
                var _spawn_grid_y = _spawn_point[1];
                
                // Calculate the pixel position (centered in the cell)
                var _pixel_x = (offset_x) + (_spawn_grid_x * CELL_SIZE) + (CELL_SIZE / 2);
                var _pixel_y = (offset_y) + (_spawn_grid_y * CELL_SIZE) + (CELL_SIZE / 2);
                
                // Create the pickup!
                var _inst = instance_create_layer(_pixel_x, _pixel_y, "Instances_Player", _powerup_obj);
                show_debug_message("Spawned " + object_get_name(_inst.object_index) + " at (" + string(_pixel_x) + ", " + string(_pixel_y) + ")");
            }
        } else {
            show_debug_message("Could not find any valid spawn points for power-ups!");
        }
        
        // Mark spawning as complete
        powerup_spawned = true;
    }
}