// 1. Draw the player sprite itself
draw_self();

// 2. If we are holding an item, draw its sprite on top of us
if (wielded_item_sprite != -1) {
    draw_sprite_ext(wielded_item_sprite, 0, x, y, wield_scale, wield_scale, 0, c_white, 1);
}

// --- Draw Wall-Break Target ---
if (current_wall_break_charges > 0 && instance_exists(o_maze_generator)) {
    
    // Use collision_line to find the wall directly in front of the player
    var _check_dist = 16; // How far to check for a wall
    var _target_x = x + (last_move_h * _check_dist);
    var _target_y = y + (last_move_v * _check_dist);
    var _wall_found = collision_line(x, y, _target_x, _target_y, o_wall_parent, false, true);

    if (_wall_found != noone) {
        // Scale the reticle to match the cell size for clear visibility
        var _scale = o_maze_generator.CELL_SIZE / sprite_get_width(s_target_reticle);
        // Snap the reticle to the wall's actual position for pixel-perfect alignment
        draw_sprite_ext(s_target_reticle, 0, _wall_found.x, _wall_found.y, _scale, _scale, 0, c_white, 0.75);
    }
}