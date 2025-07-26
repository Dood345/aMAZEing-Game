// 1. Draw the player sprite itself
draw_self();

// 2. If we are holding an item, draw its sprite on top of us
if (wielded_item_sprite != -1) {
    draw_sprite(wielded_item_sprite, 0, x, y);
}