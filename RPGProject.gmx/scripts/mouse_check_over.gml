///mouse_check_over(object)
//returns the id of the object the mouse is over
var obj = argument[0];
var width = obj.sprite_width;
var height = obj.sprite_height;

if (point_in_rectangle(mouse_x, mouse_y, obj.x - width/2, obj.y - height/2, obj.x + width/2, obj.y + height/2)) {
    return instance_nearest(mouse_x, mouse_y, obj);
}
return noone;
