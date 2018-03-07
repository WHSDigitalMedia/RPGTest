///display_inv()

//clear out old buttons
with (class_button) {
    if (clickAction != display_inv) {
        instance_destroy();
    }
}

//check what mode we're in
with (controller_combat) {
    if (mode == MOVES) {
        other.text = "Show moves";
        buttonsCreated = false;
        mode = INVENTORY;   
    } else if (mode == INVENTORY) {
        other.text = "Show inventory";
        buttonsCreated = false;
        mode = MOVES;   
    }
}

//reset controller_inventory
with (controller_inventory) {
    buttonsCreated = false;
    itemSelected = "";
    mode = ITEMS;
}
