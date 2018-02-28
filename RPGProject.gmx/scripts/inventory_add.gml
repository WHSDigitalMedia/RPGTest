///inventory_add(item 1, item 2, item 3, ...)
ini_open("item_data.ini");

for (var i = 0; i < argument_count; i++) {
    var section = argument[i];
    if (ini_section_exists(section)) {
        if (ini_key_exists(section, "type")) {
            var type = ini_read_string(section, "type", "");
            var name = ini_read_string(section, "name", "");
            switch (type) {
                case "equippable": 
                    with (controller_inventory) {
                        if (ds_list_size(equippableList) < equippableMax) {
                            ds_list_add(equippableList, name);
                        }
                    }
                    break;
                case "consumable":
                    with (controller_inventory) {
                        if (ds_list_size(consumableList) < consumableMax) {
                            ds_list_add(consumableList, name);
                        }
                    }
                    break;
                case "miscellaneous":
                    with (controller_inventory) {
                        if (ds_list_size(miscList) < miscMax) {
                            ds_list_add(miscList, name);
                        }
                    }
                    break;
                default: break;
            }
        }
    }
}

ini_close();
