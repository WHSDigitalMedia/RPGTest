#define view_equippable
///view_equippable()
with (controller_inventory) {
    mode = EQUIPPABLE;
    buttonsCreated = false;
}

#define view_consumable
///view_consumable()
with (controller_inventory) {
    mode = CONSUMABLE;
    buttonsCreated = false;
}

#define view_miscellaneous
///view_miscellaneous()
with (controller_inventory) {
    mode = MISCELLANEOUS;
    buttonsCreated = false;
}
