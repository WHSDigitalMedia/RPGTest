#define view_equippable
///view_equippable()
with (controller_inventory) {
    viewMode = EQUIPPABLE;
    buttonsCreated = false;
}

#define view_consumable
///view_consumable()
with (controller_inventory) {
    viewMode = CONSUMABLE;
    buttonsCreated = false;
}

#define view_miscellaneous
///view_miscellaneous()
with (controller_inventory) {
    viewMode = MISCELLANEOUS;
    buttonsCreated = false;
}