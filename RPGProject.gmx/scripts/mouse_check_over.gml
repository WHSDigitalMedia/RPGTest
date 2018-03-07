///mouse_check_over(object)
//returns the id of the object the mouse is over
var obj = argument[0];
var inst = instance_nearest(mouse_x, mouse_y, obj);
var width = 0;
var height = 0;

if (instance_exists(inst)) {
    width = inst.sprite_width; 
    height = inst.sprite_height;
    if (point_in_rectangle(mouse_x, mouse_y, inst.x - width/2, inst.y - height/2, inst.x + width/2, inst.y + height/2)) {
        return inst;
    }
}
return noone;
