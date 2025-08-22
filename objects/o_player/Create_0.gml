/// @description Player Variables and State

// --- BASE (Permanent) Attributes ---
base_scale = o_maze_controller.player_base_scale; // The normal size we want player to be
wielded_item_sprite = -1;
wield_scale = 0.025
base_acceleration = 0.2;
base_max_speed = 4;
base_friction_amount = 0.1;
base_stop_threshold = 0.15;
base_vision_radius = 3;
base_map_reveal_percentage = 0.05;
base_stamina = 100;
base_max_stamina = 100;
base_wall_break_charges = 0;
base_portal_charges = 0;
base_speedboost_duration = 0;

// --- CURRENT (Temporary) Attributes ---
// These are the values the game will actually use for movement, etc.
current_acceleration = base_acceleration;
current_max_speed = base_max_speed;
current_friction_amount = base_friction_amount;
current_wall_break_charges = base_wall_break_charges;
current_stop_threshold = base_stop_threshold;
current_speedboost_duration = base_speedboost_duration
// (We don't need current versions of everything, just what power-ups will change)

// --- Internal Physics Variables ---
h_speed = 0;
v_speed = 0;
last_move_h = 0; // -1 for left, 1 for right
last_move_v = 1; // -1 for up, 1 for down (default to facing down)

// --- State Machine ---
in_maze = false;

// --- HELPER METHOD: Recalculate Stats ---
// This function will be the single place where we determine the player's current stats.
recalculate_stats = function() {
    
    // 1. Reset current stats to their base values
    current_acceleration = base_acceleration;
    current_max_speed = base_max_speed;
    current_friction_amount = base_friction_amount;
    
    // 2. Apply any active effects
    // If the speed boost is active, apply its modifications
    if (current_speedboost_duration > 0) {
        current_acceleration += 0.2;
        current_max_speed += 2;
    }
    
    // If we had a "slow" debuff, we would subtract from the stats here!
    // if (slow_duration > 0) {
    //     current_max_speed -= 1;
    // }
}