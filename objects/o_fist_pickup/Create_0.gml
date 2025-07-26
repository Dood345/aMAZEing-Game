event_inherited();

// --- Fist Item Data ---
item_data = {
    name: "Fist",
    type: "powerup",
    wield_sprite: s_fist, // The sprite to draw when the player holds it
	

    // This function runs when the player picks up the item.
    apply_effect: function(_player_id) {
        
        // 1. Add one charge to the player's wall_break_charges variable.
        _player_id.current_wall_break_charges += 1;
        
        // 2. Set the player's wielded sprite so it's visually holding the fist.
        //    We will make this wear off after one use.
		wield_sprite.image_xscale = 0.0369;
		wield_sprite.image_yscale = 0.0369;
        _player_id.wielded_item_sprite = wield_sprite; 
        
        // This item doesn't need to call recalculate_stats() because it doesn't
        // affect any of the temporary movement attributes.
    }
};