/// @description Animate the scale

// Increment the timer. A smaller number makes the pulse slower.
pulse_timer += 0.08;

// Use a sine wave to get a smooth back-and-forth value between -1 and 1
var _pulse = sin(pulse_timer);

// Calculate the final scale for this frame
var _scale = base_scale + (_pulse * pulse_amount);

// Apply the scale
image_xscale = _scale;
image_yscale = _scale;