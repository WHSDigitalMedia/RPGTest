///toggle_inv_desc()
//clear out old buttons
with (class_button) {
    if (clickAction != display_inv) {
        instance_destroy();
    }
}

with (controller_inventory) {
    if (mode == ITEMS) {
        buttonsCreated = false;
        itemSelected = other.text;
        mode = DESC;
    } else if (mode == DESC) {
        buttonsCreated = false;
        itemSelected = "";
        mode = ITEMS;
    }
}
