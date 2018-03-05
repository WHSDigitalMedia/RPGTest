///pick_target()
if (mouse_check_button_pressed(mb_left)) {
    return mouse_check_over(class_npc);
    show_debug_message('click');
}
return noone;
