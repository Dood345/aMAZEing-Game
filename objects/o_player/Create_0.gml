/// @description Player Variables and State

// --- Movement Attributes ---
acceleration = 0.2;     // How quickly we speed up
max_speed = 4;          // The fastest we can move
friction_amount = 0.1;  // How quickly we slow down when no keys are pressed
stop_threshold = 0.15;  // If speed is below this, just stop completely
//move_speed = 3;
//turn_speed = 1;

// --- Internal Physics Variables ---
h_speed = 0; // Current horizontal speed
v_speed = 0; // Current vertical speed

// --- Attributes ---
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