/// @description Draw the maze grid (centered).

// Loop through every cell in the grid
for (var i = 0; i < MAZE_WIDTH; i++) {
    for (var j = 0; j < MAZE_HEIGHT; j++) {
        var _cell = grid[i][j];
        
        // Calculate the screen coordinates, APPLYING THE OFFSET
        var _x1 = (i * CELL_SIZE) + offset_x; // <-- CHANGE HERE
        var _y1 = (j * CELL_SIZE) + offset_y; // <-- CHANGE HERE
        var _x2 = _x1 + CELL_SIZE;
        var _y2 = _y1 + CELL_SIZE;
        
        // --- Draw the background color for visualization ---
        if (_cell.visited) {
            draw_set_color(c_purple);
            draw_rectangle(_x1, _y1, _x2, _y2, false);
        }
        
        // --- Draw the walls ---
        draw_set_color(c_white);
        draw_set_alpha(1);
        
        if (_cell.wall_north) { draw_line(_x1, _y1, _x2, _y1); }
        if (_cell.wall_south) { draw_line(_x1, _y2, _x2, _y2); }
        if (_cell.wall_east)  { draw_line(_x2, _y1, _x2, _y2); }
        if (_cell.wall_west)  { draw_line(_x1, _y1, _x1, _y2); }
    }
}

if (!ds_stack_empty(path_stack)) {
    var _current_cell = ds_stack_top(path_stack);
    
    // Apply the offset here as well!
    var _x1 = (_current_cell.x * CELL_SIZE) + offset_x;
    var _y1 = (_current_cell.y * CELL_SIZE) + offset_y;
    
    draw_set_color(c_lime);
    draw_rectangle(_x1, _y1, _x1 + CELL_SIZE, _y1 + CELL_SIZE, false);
}

// Draw the Start and End points only after the maze is complete
if (generation_complete) {
    
    // --- Draw Start Point (Green) ---
    var _start_x1 = (start_cell_x * CELL_SIZE) + offset_x;
    var _start_y1 = (start_cell_y * CELL_SIZE) + offset_y;
    
    draw_set_color(c_green);
    draw_rectangle(_start_x1, _start_y1, _start_x1 + CELL_SIZE, _start_y1 + CELL_SIZE, false);
    
    // --- Draw End Point (Red) ---
    var _end_x1 = (end_cell_x * CELL_SIZE) + offset_x;
    var _end_y1 = (end_cell_y * CELL_SIZE) + offset_y;
    
    draw_set_color(c_red);
    draw_rectangle(_end_x1, _end_y1, _end_x1 + CELL_SIZE, _end_y1 + CELL_SIZE, false);
    
    // Reset color to white so we don't affect other drawings
    draw_set_color(c_white);
}