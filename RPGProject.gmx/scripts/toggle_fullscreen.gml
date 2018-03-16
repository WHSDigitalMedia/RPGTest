///toggle_fullscreen()
window_set_fullscreen(!window_get_fullscreen());
var a = application_get_position();
var xx = a[0];
var yy = a[1];
var ww = a[2] - a[0];
var hh = a[3] - a[1];
if (window_get_fullscreen()) {
    display_set_gui_maximise(display_get_width()/room_width, display_get_height()/room_height, xx, yy);
} else {
    display_set_gui_maximise(window_get_width()/room_width, window_get_height()/room_height, xx, yy);
}
