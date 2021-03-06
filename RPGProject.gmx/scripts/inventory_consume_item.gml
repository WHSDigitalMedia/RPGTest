///inventory_consume_item()
//basically inventory_equip's code, will revise later, maybe
ini_open("item_data.ini");
var _tempList = ds_list_create();
var type = "";

//get the type of the item being equipped
if (ini_section_exists(text)) {
    if (ini_key_exists(text, "subtype")) {
        type = ini_read_string(text, "subtype", "");
    }
}

//change stat value
var n = 1;
do {
    var amt = ini_read_real(text, "amt" + string(n), 0);
    with (class_player) {
        stat[ini_read_real(other.text, "stat" + string(n), 0)] += amt;
    }
    n++;
} until (!ini_key_exists(text, "stat" + string(n)));

var numBefore = 0; //number of duplicate items before this one
var yPos = 0;

//scan all the buttons above and below this one
do {
    var inst = instance_position(x, yPos, class_button);
    if (inst) { //if we actually "scanned" something
        if (ds_list_find_index(_tempList, inst) == -1) { //run this only if it's not in the list
            //if we found ourselves, skip to the end, we're the first one in the list
            if (inst == self) {
                yPos = room_height;
            } else if (inst.text == text) { 
                //if we found a duplicate, increase numBefore
                //we're not the first in this list
                numBefore++;
            }
            //add to the collision list so we don't scan this thing again
            ds_list_add(_tempList, inst);
        }
    }
    //increase y value so the vertical scan goes downward
    yPos++;
} until (yPos >= room_height); //until we hit the bottom of the screen

//counter needs to match the number of items we want to skip before
//we remove a value
var counter = 0;
with (controller_inventory) {
    for (var j = 0; j < ds_list_size(consumableList); j++) {
        var name = ds_list_find_value(consumableList, j);
        //if the thing in the list has the same name as us
        if (name == other.text) {
            //delete that thing if we were the first one
            if (counter == numBefore) {
                ds_list_delete(consumableList, j);
                j = ds_list_size(consumableList);
            } else {
                //otherwise keep checking, increasing counter
                //so that it equals the number to skip
                counter++;
            }
        }
    }
}


//get rid of the ds_list to prevent memory leaking
if (ds_exists(_tempList, ds_type_list)) {
    ds_list_destroy(_tempList);
}
ini_close();

instance_destroy();
