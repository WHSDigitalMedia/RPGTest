#define pause_game
///pause_game()
with (controller_pause) {
    //returns to the overworld
    if (global.pause != global.UNPAUSE) {
        texture_set_interpolation(false);
        room_goto(roomIndex);
        global.pause = global.UNPAUSE;
        with (class_player) {
            allowMovement = true;
            allowInput = true;
            visible = true;
        }
    } else { //saves the player's current room
        with (class_npc) { //they're annoying
            persistent = false;
        }
        global.pause = global.STANDARD_PAUSE;
        roomIndex = room;
        draw = true;
    }
}

#define open_inventory
///open_inventory()
with (controller_pause) {
    if (global.pause == global.INVENTORY_PAUSE) {
        room_goto(roomIndex);
        global.pause = global.UNPAUSE;
        with (class_player) {
            allowMovement = true;
            allowInput = true;
            visible = true;
        }
    } else if (room != rm_pause_menu && room != rm_text_interaction && room != rm_map_menu) {
        with (class_npc) {
            persistent = false;
        }
        global.pause = global.INVENTORY_PAUSE;
        roomIndex = room;
        room_goto(rm_inventory_menu);
    }
}

#define open_map
///open_map()
with (controller_pause) {
    if (global.pause == global.MAP_PAUSE) {
        room_goto(roomIndex);
        global.pause = global.UNPAUSE;
        with (class_player) {
            allowMovement = true;
            allowInput = true;
            visible = true;
        }
    } else if (room != rm_pause_menu && room != rm_text_interaction && room != rm_inventory_menu) {
        with (class_npc) {
            persistent = false;
        }
        global.pause = global.MAP_PAUSE;
        roomIndex = room;
        room_goto(rm_map_menu);
    }
}
#define init_combat
///init_combat()
with (controller_pause) {
    global.pause = global.COMBAT_PAUSE;
    with (class_npc) {
        visible = true;
    }
    room_goto(rm_combat_interaction);
}