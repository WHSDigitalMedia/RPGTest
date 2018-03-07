///pick_target()

//returns the id of the target we clicked on
if (mouse_check_button_pressed(mb_left)) {
    return mouse_check_over(class_nonGUI);
}
return noone;
