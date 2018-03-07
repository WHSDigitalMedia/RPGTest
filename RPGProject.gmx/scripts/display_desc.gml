///display_desc()
with (controller_combat) {
    if (mode == MOVES) {
        moveSelected = other.text;
        buttonsCreated = false;
        mode = MOVES_DESC;
        show_debug_message(moveSelected);
    } else if (mode == MOVES_DESC) {
        moveSelected = "";
        buttonsCreated = false;
        mode = MOVES;
    }
}
