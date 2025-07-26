/// @description Player Variables and State

// --- Attributes ---
move_speed = 3;
turn_speed = 1;
vision_radius = 3;
map_reveal_percentage = 0.05;
wall_break_charges = 0;
portal_charges = 0;
drone_duration = 0;
speed_boost_duration = 0;
stamina = 100;
max_stamina = 100;

// --- State Machine ---
// We start in a "waiting" state.
has_spawned = false;