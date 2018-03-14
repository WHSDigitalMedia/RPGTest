#define end_conversation
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
    alarm_set(1, 1); //delay to reset persistency
}
global.pause = global.UNPAUSE;

#define end_conversation_destroy
///end_conversation_destroy()
//like end_conversation, but now the calling instance is destroyed
//so that it can't be used again
with (class_npc) {
    instance_destroy();
}
end_conversation();