/// @description Player Movement with Collisions

// --- Get Keyboard Input ---
var _key_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var _key_left = keyboard_check(vk_left) || keyboard_check(ord("A"));
var _key_down = keyboard_check(vk_down) || keyboard_check(ord("S"));
var _key_up = keyboard_check(vk_up) || keyboard_check(ord("W"));

var _move_horizontal = _key_right - _key_left;
var _move_vertical = _key_down - _key_up;

// --- Calculate distance to move ---
var _move_x = _move_horizontal * move_speed;
var _move_y = _move_vertical * move_speed;


// --- HORIZONTAL COLLISION ---
// Check if a wall is at our target destination
if (place_meeting(x + _move_x, y, o_wall)) {
    // If so, move pixel by pixel until we are right next to it
    while (!place_meeting(x + sign(_move_x), y, o_wall)) {
        x = x + sign(_move_x);
    }
    // Then, stop.
    _move_x = 0;
}
// Apply the horizontal movement
x = x + _move_x;


// --- VERTICAL COLLISION ---
// Check if a wall is at our target destination
if (place_meeting(x, y + _move_y, o_wall)) {
    // If so, move pixel by pixel until we are right next to it
    while (!place_meeting(x, y + sign(_move_y), o_wall)) {
        y = y + sign(_move_y);
    }
    // Then, stop.
    _move_y = 0;
}
// Apply the vertical movement
y = y + _move_y;