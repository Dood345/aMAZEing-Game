if (current_wall_break_charges > 0) {
    
    var _dir_x = sign(h_speed);
    var _dir_y = sign(v_speed);
    
    // Prioritize horizontal direction if moving diagonally
    if (_dir_x != 0) { _dir_y = 0; }
    
    // Don't break walls if we are standing still
    if (_dir_x != 0 || _dir_y != 0) {
        
        // Calculate a check position one pixel in the direction we're moving
        var _check_x = x + _dir_x;
        var _check_y = y + _dir_y;
        
        // Find the specific wall instance that is at that check position
        var _wall_to_break = instance_place(_check_x, _check_y, o_wall_parent);
        
        // If we found a wall...
        if (_wall_to_break != noone) {
            
            // We found a valid wall! Now use the charge.
            current_wall_break_charges -= 1;
            
            // Destroy the specific instance we found
            instance_destroy(_wall_to_break);
            
            // You could create a dust/explosion particle effect here!
            
            // If that was our last charge, stop wielding the fist sprite.
            if (current_wall_break_charges <= 0) {
                wielded_item_sprite = -1;
            }
        }
    }
}