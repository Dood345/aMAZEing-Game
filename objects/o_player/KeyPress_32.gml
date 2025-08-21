// --- Wall Breaking Logic (Grid-Based) ---
if (current_wall_break_charges > 0 && in_maze) {
    
    // Use collision_line to find the wall directly in front of the player
    var _check_dist = 16; // How far to check for a wall
    var _target_x = x + (last_move_h * _check_dist);
    var _target_y = y + (last_move_v * _check_dist);
    var _wall_to_break = collision_line(x, y, _target_x, _target_y, o_wall_parent, false, true);
    
    if (_wall_to_break != noone) {
        instance_destroy(_wall_to_break);
        current_wall_break_charges -= 1;

        // If that was the last charge, remove the fist icon
        if (current_wall_break_charges == 0) {
            wielded_item_sprite = -1;
        }
    }
}