#define pause_game
///pause_game()
with (controller_pause) {
    //returns to the overworld
    if (global.pause != global.UNPAUSE) {
        texture_set_interpolation(false);
        room_goto(roomIndex);
        with (class_player) {
            allowMovement = true;
            allowInput = true;
            visible = true;
            if (global.pause == global.COMBAT_PAUSE) {
                x = other.savedPlayerX;
                y = other.savedPlayerY;
            }
        }
        global.pause = global.UNPAUSE;
    } else { //saves the player's current room
        with (class_npc) { //they're annoying
            persistent = false;
        }
        roomIndex = room;
        draw = true;
        global.pause = global.STANDARD_PAUSE;
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
        roomIndex = room;
        //setting the approx room for the map
        if (roomIndex == rm_flan_bedroom || rm_flan_main_room || rm_flan_outside_home) {
            approxRoom = rm_flan_main_room;
        }
        room_goto(rm_map_menu);
        global.pause = global.MAP_PAUSE;
    }
}

#define init_combat
///init_combat()

with (controller_pause) {
    global.pause = global.COMBAT_PAUSE;
    with (class_player) {
        visible = true;
    }
    with (class_npc) {
        visible = true;
    }
    var inst = instance_find(class_npc, 0);
    savedNPCX = inst.x;
    savedNPCY = inst.y
    createNPC = inst.object_index;
    savedPlayerX = class_player.x;
    savedPlayerY = class_player.y;
    room_goto(rm_combat_interaction);
}
