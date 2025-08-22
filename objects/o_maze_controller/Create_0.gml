/// @description Initialize Maze Generator
randomize();
// -- MAZE CONFIGURATION --
// Feel free to change these values
MAZE_WIDTH = 40;  // Number of cells wide
MAZE_HEIGHT = 22; // Number of cells high
CELL_SIZE = 24;   // Size of each cell in pixels

// -- POWER-UP CONFIGURATION --
powerup_types = [o_speedup_pickup, o_fist_pickup]; // The list of power-ups to spawn
powerup_min_dist = 10; // Minimum distance from the player start to spawn a power-up
powerup_max_dist = 30; // Maximum distance from the player start to spawn a power-up

// -- BASE_SCALES --
powerup_base_scale = 0.0369;
player_base_scale = 0.125;

// -- INTERNAL VARIABLES --
grid = [];
path_stack = ds_stack_create();
generation_complete = false;
player_spawned = false;
powerup_spawned = false;
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
/// @return {Array<Any>} An array containing the unvisited neighbor cells (structs).
get_unvisited_neighbors = function(cx, cy) {
    var _neighbors = [];
    
    // Check North
    if (cy > 0) {
        var _neighbor = grid[cx][cy - 1];
        if (!_neighbor.visited) {
            array_push(_neighbors, _neighbor);
        }
    }
    // Check East
    if (cx < MAZE_WIDTH - 1) {
        var _neighbor = grid[cx + 1][cy];
        if (!_neighbor.visited) {
            array_push(_neighbors, _neighbor);
        }
    }
    // Check South
    if (cy < MAZE_HEIGHT - 1) {
        var _neighbor = grid[cx][cy + 1];
        if (!_neighbor.visited) {
            array_push(_neighbors, _neighbor);
        }
    }
    // Check West
    if (cx > 0) {
        var _neighbor = grid[cx - 1][cy];
        if (!_neighbor.visited) {
            array_push(_neighbors, _neighbor);
        }
    }
    
    return _neighbors;
}


/// @function remove_wall_between(cell_a, cell_b)
/// @description Removes the wall between two adjacent cells.
/// @param {struct.Cell} _cell_a The first cell.
/// @param {struct.Cell} _cell_b The second cell.
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

/// @function reset_maze()
/// @description Resets all variables to generate a new maze.
reset_maze = function() {
    
    // 1. Reset all the state variables using 'self'
    self.generation_complete = false;
    self.player_spawned = false;
    self.powerup_spawned = false;
    self.walls_built = false;
    self.start_cell_x = -1;
    self.start_cell_y = -1;
    self.end_cell_x = -1;
    self.end_cell_y = -1;

    if (instance_exists(o_player)) {
        o_player.in_maze = false;
        o_player.visible = false;
    }

    // 2. Clear out the old data structures
    ds_stack_destroy(self.path_stack);
    self.path_stack = ds_stack_create();
    self.grid = [];
    
    // 3. Destroy all the old wall objects
    instance_destroy(o_wall_parent);
    
    // 4. Re-run the initialization logic to create a new grid
    for (var i = 0; i < self.MAZE_WIDTH; i++) {
        self.grid[i] = [];
        for (var j = 0; j < self.MAZE_HEIGHT; j++) {
            self.grid[i][j] = new Cell(i, j);
        }
    }
    
    // 5. Pick a new random start point and push it to the stack
    var _start_x = irandom(self.MAZE_WIDTH - 1);
    var _start_y = irandom(self.MAZE_HEIGHT - 1);
    var _start_cell = self.grid[_start_x][_start_y];
    _start_cell.visited = true;
    ds_stack_push(self.path_stack, _start_cell);
}

/// @function find_spawn_locations(_start_x, _start_y, _min_dist, _max_dist)
/// @description Helper function uses BFS to find all open grid cells within a distance range.
find_spawn_locations = function(_start_x, _start_y, _min_dist, _max_dist) {
    
    var _queue = ds_list_create();
    var _locations = []; // This will store our results
    
    // Create a 'visited' grid to avoid checking the same cell twice
    var _visited = array_create(MAZE_WIDTH, false);
    for (var i = 0; i < MAZE_WIDTH; i++) {
        _visited[i] = array_create(MAZE_HEIGHT, false);
    }
    
    // Add the starting point to the queue: [x, y, current_distance]
    ds_list_add(_queue, [_start_x, _start_y, 0]);
    _visited[_start_x][_start_y] = true;
    
    // Loop until we've checked every reachable cell
    while (!ds_list_empty(_queue)) {
        var _current = _queue[| 0];
		ds_list_delete(_queue, 0);
        var cx = _current[0];
        var cy = _current[1];
        var _cdist = _current[2];
        
        // If this cell is within our desired distance range, add it to our results!
        if (_cdist >= _min_dist && _cdist <= _max_dist) {
            array_push(_locations, [cx, cy]);
        }
        
        // If we've gone past our max distance, we don't need to explore further from this branch
        if (_cdist > _max_dist) {
            continue;
        }
        
        // --- Explore Neighbors ---
		var _cell = grid[cx][cy]; // Get the current cell we are exploring FROM

		// Check UP
		if (cy > 0 && !_visited[cx][cy - 1] && !_cell.wall_north) {
		    _visited[cx][cy - 1] = true;
		    ds_list_add(_queue, [cx, cy - 1, _cdist + 1]);
		}
		// Check DOWN
		if (cy < MAZE_HEIGHT - 1 && !_visited[cx][cy + 1] && !_cell.wall_south) {
		    _visited[cx][cy + 1] = true;
		    ds_list_add(_queue, [cx, cy + 1, _cdist + 1]);
		}
		// Check LEFT
		if (cx > 0 && !_visited[cx - 1][cy] && !_cell.wall_west) {
		    _visited[cx - 1][cy] = true;
		    ds_list_add(_queue, [cx - 1, cy, _cdist + 1]);
		}
		// Check RIGHT
		if (cx < MAZE_WIDTH - 1 && !_visited[cx + 1][cy] && !_cell.wall_east) {
		    _visited[cx + 1][cy] = true;
		    ds_list_add(_queue, [cx + 1, cy, _cdist + 1]);
		}
    }
    
    ds_list_destroy(_queue); // Clean up memory
    return _locations;
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