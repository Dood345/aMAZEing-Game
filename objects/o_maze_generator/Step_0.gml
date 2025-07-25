/// @description Perform one step of maze generation.

// If the stack is empty, we are done!
if (ds_stack_empty(path_stack)) {
    generation_complete = true;
    
    // --- BUILD THE PHYSICAL WALLS (runs only once) ---
    if (!walls_built) {
        
        // Loop through every cell to place the walls
        for (var i = 0; i < MAZE_WIDTH; i++) {
            for (var j = 0; j < MAZE_HEIGHT; j++) {
                var _cell = grid[i][j];
                
                // Calculate the real-world position, including the center offset
                var _x_pos = (i * CELL_SIZE) + offset_x;
                var _y_pos = (j * CELL_SIZE) + offset_y;
                
                // Place a wall object if the cell has a wall
                if (_cell.wall_north) { instance_create_layer(_x_pos, _y_pos, "Instances", o_wall); }
                if (_cell.wall_south) { instance_create_layer(_x_pos, _y_pos + CELL_SIZE, "Instances", o_wall); }
                if (_cell.wall_east)  { instance_create_layer(_x_pos + CELL_SIZE, _y_pos, "Instances", o_wall); }
                if (_cell.wall_west)  { instance_create_layer(_x_pos, _y_pos, "Instances", o_wall); }
            }
        }
        
        walls_built = true; // Mark the walls as built so we don't do it again
    }
    
    exit; // Exit the script for this frame
}

// 1. Get the current cell from the top of the stack
var _current_cell = ds_stack_top(path_stack);

// 2. Find its unvisited neighbors
var _neighbors = get_unvisited_neighbors(_current_cell.x, _current_cell.y);

// 3. If there are unvisited neighbors...
if (array_length(_neighbors) > 0) {
    // a. Pick one at random
    var _next_cell = _neighbors[irandom(array_length(_neighbors) - 1)];
    
    // b. Push the chosen neighbor to the stack
    ds_stack_push(path_stack, _next_cell);
    
    // c. Remove the wall between the current and chosen cell
    remove_wall_between(_current_cell, _next_cell);
    
    // d. Mark the chosen cell as visited
    _next_cell.visited = true;
}
// 4. If there are NO unvisited neighbors...
else {
    // Backtrack by popping the current cell from the stack
    ds_stack_pop(path_stack);
}