///end_conversation();
texture_set_interpolation(false);
with (gui_textbox) {
    instance_destroy();
}

room_goto(controller_pause.roomIndex);
with (class_player) {
    allowMovement = true;
    allowInput = true;
}
with (class_npc) {
    persistent = false;
}
global.pause = global.UNPAUSE;
