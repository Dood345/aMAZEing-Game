/// @description cleanup on exit
if (surface_exists(fog_surface)) {
    surface_free(fog_surface);
}