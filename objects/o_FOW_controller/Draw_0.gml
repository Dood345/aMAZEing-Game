/// @description Draw fog of war gui
if (!surface_exists(fog_surface)) return;

// Get shader uniforms
var time_uniform = shader_get_uniform(shd_FOW_ripple, "u_time");
var freq_uniform = shader_get_uniform(shd_FOW_ripple, "u_frequency");
var amp_uniform = shader_get_uniform(shd_FOW_ripple, "u_amplitude");
var fog_uniform = shader_get_sampler_index(shd_FOW_ripple, "u_fog_texture");

// Set shader and uniforms
shader_set(shd_FOW_ripple);
shader_set_uniform_f(time_uniform, ripple_time);
shader_set_uniform_f(freq_uniform, ripple_frequency);
shader_set_uniform_f(amp_uniform, ripple_amplitude);

// Bind fog texture to the shader
texture_set_stage(fog_uniform, surface_get_texture(fog_surface));

// Draw the fog over everything
gpu_set_blendmode_ext(bm_src_color, bm_inv_src_alpha);
draw_surface_ext(fog_surface, 0, 0, 1, 1, 0, c_white, 0.8);
gpu_set_blendmode(bm_normal);

shader_reset();