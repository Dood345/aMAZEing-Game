/// @description Initialize Maze Generator
randomize();
// -- MAZE CONFIGURATION --
// Feel free to change these values
MAZE_WIDTH = 40;  // Number of cells wide
MAZE_HEIGHT = 22; // Number of cells high
CELL_SIZE = 24;   // Size of each cell in pixels

// -- INTERNAL VARIABLES --
grid = [];
path_stack = ds_stack_create();
generation_complete = false;
start_cell_x = -1; // -1 means not set yet
start_cell_y = -1;
end_cell_x = -1;
end_cell_y = -1;

// -- CELL CONSTRUCTOR --
// A struct to hold the data for each individual cell in the maze
function Cell(_x, _y) constructor {
    x = _x;
    y = _y;
    
    visited = false;
    
    // Each cell starts with all four walls intact
    wall_north = true;
    wall_south = true;
    wall_east = true;
    wall_west = true;
}


// -- HELPER METHODS --
// We now define these as variables holding functions to bind them as methods.
// This is the fix for the error.

/// @function get_unvisited_neighbors(cx, cy)
/// @description Finds all valid, unvisited neighbors for a given cell.
/// @param {real} cx   The x-coordinate of the cell in the grid.
/// @param {real} cy   The y-coordinate of the cell in the grid.
/// @return {array} An array containing the unvisited neighbor cells (structs).
get_unvisited_neighbors = function(_cx, _cy) {
    var _neighbors = [];
    
    // Check North
    if (_cy > 0) {
        var _neighbor = grid[_cx][_cy - 1];
        if (!_neighbor.visited) {
            array_push(_neighbors, _neighbor);
        }
    }
    // Check East
    if (_cx < MAZE_WIDTH - 1) {
        var _neighbor = grid[_cx + 1][_cy];
        if (!_neighbor.visited) {
            array_push(_neighbors, _neighbor);
        }
    }
    // Check South
    if (_cy < MAZE_HEIGHT - 1) {
        var _neighbor = grid[_cx][_cy + 1];
        if (!_neighbor.visited) {
            array_push(_neighbors, _neighbor);
        }
    }
    // Check West
    if (_cx > 0) {
        var _neighbor = grid[_cx - 1][_cy];
        if (!_neighbor.visited) {
            array_push(_neighbors, _neighbor);
        }
    }
    
    return _neighbors;
}


/// @function remove_wall_between(cell_a, cell_b)
/// @description Removes the wall between two adjacent cells.
/// @param {struct.Cell} cell_a The first cell.
/// @param {struct.Cell} cell_b The second cell.
remove_wall_between = function(_cell_a, _cell_b) {
    var _dx = _cell_a.x - _cell_b.x;
    // _cell_a is to the east of _cell_b
    if (_dx == 1) {
        _cell_a.wall_west = false;
        _cell_b.wall_east = false;
    }
    // _cell_a is to the west of _cell_b
    else if (_dx == -1) {
        _cell_a.wall_east = false;
        _cell_b.wall_west = false;
    }
    
    var _dy = _cell_a.y - _cell_b.y;
    // _cell_a is to the south of _cell_b
    if (_dy == 1) {
        _cell_a.wall_north = false;
        _cell_b.wall_south = false;
    }
    // _cell_a is to the north of _cell_b
    else if (_dy == -1) {
        _cell_a.wall_south = false;
        _cell_b.wall_north = false;
    }
}


// -- INITIALIZATION LOGIC --

// 1. Create the 2D array and populate it with Cell structs
for (var i = 0; i < MAZE_WIDTH; i++) {
    grid[i] = []; // Initialize the inner array
    for (var j = 0; j < MAZE_HEIGHT; j++) {
        grid[i][j] = new Cell(i, j);
    }
}

// 2. Choose a random starting point
var _start_x = irandom(MAZE_WIDTH - 1);
var _start_y = irandom(MAZE_HEIGHT - 1);
var _start_cell = grid[_start_x][_start_y];

// 3. Mark the starting cell as visited and push it to the stack
_start_cell.visited = true;
ds_stack_push(path_stack, _start_cell);

// Calculate the total size of the maze in pixels
var _total_maze_width = MAZE_WIDTH * CELL_SIZE;
var _total_maze_height = MAZE_HEIGHT * CELL_SIZE;

// Get the size of the camera's view (which is usually the window size)
var _cam_width = camera_get_view_width(view_camera[0]);
var _cam_height = camera_get_view_height(view_camera[0]);

// Calculate the top-left position to start drawing from
offset_x = (_cam_width - _total_maze_width) / 2;
offset_y = (_cam_height - _total_maze_height) / 2;

walls_built = false;

spawn_ps_instance = part_system_create(ps_spawn);