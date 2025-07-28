/// @description Draw Player UI Elements

// First, make sure the player actually exists to avoid crashes.
if (!instance_exists(o_player)) {
    exit; // If no player, don't draw anything.
} else if (!o_player.has_spawned) {
	exit;
}

// --- Draw Wall Break Charges ---

// 1. Define where on the screen we want to draw the UI.
//    Let's put it in the top-left corner with a little padding.
var _ui_x = 16;
var _ui_y = 16;

// 2. Get the player's current wall break charges.
//    We use o_player. because this code is running from o_ui_controller.
var _charges = o_player.current_wall_break_charges;

// 3. Draw the icon for the power-up.
//    We'll use s_fist_pickup, or whatever you named your fist sprite.
draw_sprite_ext(s_fist, 0, _ui_x, _ui_y-20, 0.05, 0.05, 0, c_white, 1);

// 4. Draw the text showing the number of charges.
//    Set font alignment to make positioning easy.
draw_set_halign(fa_left);   // Horizontal alignment (left)
draw_set_valign(fa_middle); // Vertical alignment (middle)
draw_set_font(f_main);      // Use your main game font (we might need to create this)

// Draw the text right next to the sprite, with a little more padding.
// We add 32 to _ui_x because our sprite is probably 24-32 pixels wide.
draw_text(_ui_x + 32, _ui_y, string(_charges));

// --- Good practice: Reset draw settings when you're done ---
draw_set_halign(fa_left);
draw_set_valign(fa_top);