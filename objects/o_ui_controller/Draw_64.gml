/// @description Draw Player UI Elements

// First, make sure the player actually exists to avoid crashes.
if (!instance_exists(o_player)) {
    exit; // If no player or player hasn't spawned, don't draw anything.
}

// --- UI Positioning ---
var _ui_x = 32;
var _ui_y = 32;

// --- Set Font and Alignment ---
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_font(f_main);

// --- Draw Wall Break Charges ---
var _charges = o_player.current_wall_break_charges;
var _ui_fist_y = _ui_y + 40;
draw_sprite_ext(s_fist, 0, _ui_x, _ui_fist_y, 0.05, 0.05, 0, c_white, 1);
draw_set_color(c_white);
draw_text(_ui_x + 32, _ui_fist_y, string(_charges));

// --- Draw Current Speed ---
var _speed_x = _ui_x;
var _speed_y = _ui_y;
var _speed = o_player.current_max_speed;
draw_sprite_ext(s_speedup, 0, _speed_x, _speed_y, 0.05, 0.05, 0, c_white, 1);
draw_set_color(c_white);
draw_text(_speed_x + 32, _speed_y, string(_speed));

// --- Good practice: Reset draw settings when you're done ---
draw_set_halign(fa_left);
draw_set_valign(fa_top);