#define view_equippable
///view_equippable()
//get rid of any old buttons
with (class_button) {
    if (sprite_index == spr_inv_button) {
        instance_destroy();
    }
}
with (controller_inventory) {
    viewMode = EQUIPPABLE;
    buttonsCreated = false;
}

#define view_consumable
///view_consumable()
//get rid of any old buttons
with (class_button) {
    if (sprite_index == spr_inv_button) {
        instance_destroy();
    }
}
with (controller_inventory) {
    viewMode = CONSUMABLE;
    buttonsCreated = false;
}

#define view_miscellaneous
///view_miscellaneous()
//get rid of any old buttons
with (class_button) {
    if (sprite_index == spr_inv_button) {
        instance_destroy();
    }
}
with (controller_inventory) {
    viewMode = MISCELLANEOUS;
    buttonsCreated = false;
}
