/// @description Draw Player UI Elements

// First, make sure the player actually exists to avoid crashes.
if (!instance_exists(o_player)) {
    exit; // If no player or player hasn't spawned, don't draw anything.
}

// --- UI Positioning ---
var _ui_x = 32;
var _ui_y = 32;
var _stat_padding = 24; // Padding around the stats
var _stat_width = 80; // Width of the stat background
var _stat_height = 40; // Height of the stat background
var _border_thickness = 2; // Thickness of the border
var _corner_radius = 10; // The radius of the rounded corners

// --- Set Font and Alignment ---
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_font(f_main);

// --- Draw Wall Break Charges ---
var _charges = o_player.current_wall_break_charges;
var _ui_fist_y = _ui_y + 50; // Adjusted y position for spacing

// Draw the rounded border
draw_set_color(c_red);
draw_roundrect_ext(
    _ui_x - _stat_padding - _border_thickness,
    _ui_fist_y - (_stat_height / 2) - _border_thickness,
    _ui_x + _stat_width + _border_thickness,
    _ui_fist_y + (_stat_height / 2) + _border_thickness,
    _corner_radius + _border_thickness,
    _corner_radius + _border_thickness,
    false
);

// Draw the rounded background
draw_set_color(c_gray);
draw_roundrect_ext(
    _ui_x - _stat_padding,
    _ui_fist_y - (_stat_height / 2),
    _ui_x + _stat_width,
    _ui_fist_y + (_stat_height / 2),
    _corner_radius,
    _corner_radius,
    false
);


// Draw the sprite and text
draw_sprite_ext(s_fist, 0, _ui_x, _ui_fist_y, 0.05, 0.05, 0, c_white, 1);
draw_set_color(c_white);
draw_text(_ui_x + 32, _ui_fist_y, string(_charges));

// --- Draw Current Speed ---
var _speed_x = _ui_x;
var _speed_y = _ui_y;
var _speed = o_player.current_max_speed;

// Draw the rounded border
draw_set_color(c_red);
draw_roundrect_ext(
    _speed_x - _stat_padding - _border_thickness,
    _speed_y - (_stat_height / 2) - _border_thickness,
    _speed_x + _stat_width + _border_thickness,
    _speed_y + (_stat_height / 2) + _border_thickness,
    _corner_radius + _border_thickness,
    _corner_radius + _border_thickness,
    false
);

// Draw the rounded background
draw_set_color(c_gray);
draw_roundrect_ext(
    _speed_x - _stat_padding,
    _speed_y - (_stat_height / 2),
    _speed_x + _stat_width,
    _speed_y + (_stat_height / 2),
    _corner_radius,
    _corner_radius,
    false
);


// Draw the sprite and text
draw_sprite_ext(s_speedup, 0, _speed_x, _speed_y, 0.05, 0.05, 0, c_white, 1);
draw_set_color(c_white);
draw_text(_speed_x + 32, _speed_y, string(_speed));

// --- Good practice: Reset draw settings when you're done ---
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white); // Also reset color to avoid other elements being drawn in the last used color