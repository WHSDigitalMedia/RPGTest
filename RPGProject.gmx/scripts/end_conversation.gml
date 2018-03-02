///end_conversation();
texture_set_interpolation(false);
room_goto(controller_pause.roomIndex);
with (class_player) {
    allowMovement = true;
    allowInput = true;
}
global.pause = global.UNPAUSE;
