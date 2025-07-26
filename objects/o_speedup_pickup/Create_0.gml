event_inherited();

// --- Speedup Item Data ---
item_data = {
    name: "Speed Boost",
    type: "powerup",
    wield_sprite: -1, // This item is instant, so we don't wield it

    // This is the magic. We store the code to run in a function!
    apply_effect: function(_player_id) {
        
        // 1. Set the duration timer
        _player_id.current_speedboost_duration = 300;
            
        // 2. Tell the player to update their stats
        _player_id.recalculate_stats();
        
        // We can even play a sound here!
        // audio_play_sound(snd_powerup, 1, false);
    }
};