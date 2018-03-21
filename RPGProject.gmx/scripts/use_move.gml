///use_move()
ini_open("move_data.ini");

//find the move that matches the one you want to use
var move = 0;
var name = "";
var type = 0;
var amt = 0;
var affect = 0;
var cost = 0;
do {
    name = ini_read_string(string(move), "name", "");
    type = ini_read_real(string(move), "type", 0);
    amt = ini_read_real(string(move), "amount", 0);
    effect = ini_read_real(string(move), "stat", 0);
    cost = ini_read_real(string(move), "cost", 0);
    move++;
} until (name == text);

//pick a target
if (type == 0 || type == 2 || type == 4) {
    with (controller_combat) {
        moveSelected = other.text;
    }
} else { //multi target
    var dmg;
    if (type == 1) {
        for (var i = 0; i < instance_number(class_npc); i++) {
            var inst = instance_find(class_npc, i);
            if (inst.alignment == inst.ENEMY) {
                if (effect == 0) {
                    dmg = amt + class_player.stat[class_player.PWR] - inst.stat[inst.DEF];
                } else if (effect == 1) {
                    dmg = amt + class_player.stat[class_player.CPWR] - inst.stat[inst.CDEF];
                }
                with (inst) {
                    stat[HP] -= dmg;
                }
            }
        }
    } else if (type == 3) {
        for (var i = 0; i < instance_number(class_npc); i++) {
            var inst = instance_find(class_npc, i);
            if (inst.alignment == inst.ALLY) {
                with (inst) {
                    stat[HP] += amt;
                }
            }
        }
    } else if (type == 5) {
        if (amt > 0) {
            targ = ALLY;
        } else if (amt < 0) {
            targ = ENEMY;
        }
        for (var i = 0; i < instance_number(class_npc); i++) {
            var inst = instance_find(class_npc, i);
            if (inst.alignment == inst.targ) {
                with (inst) {
                    stat[effect] += amt;
                }
            }
        }
    }
    with (class_player) {
        stat[MP] -= cost;
    }
    
    //get the next person to go
    controller_combat.instanceSelected = false;   
}

ini_close();
