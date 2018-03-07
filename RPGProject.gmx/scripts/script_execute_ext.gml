///script_execute_ext(script, arg0, arg1, arg2, ...)
var numArgs = 0;
var script = argument[0];

for (var i = 1; i < argument_count; i++) {
    if (argument[i] != "") {
        numArgs++;
    }
}

switch (numArgs) {
    case 0:
        script_execute(script);
        break;
    case 1:
        script_execute(script, argument[1]);
        break;
    case 2:
        script_execute(script, argument[1], argument[2]);
        break;
    case 3:
        script_execute(script, argument[1], argument[2], argument[3]);
        break;
    case 4:
        script_execute(script, argument[1], argument[2], argument[3], argument[4]);
        break;
    case 5:
        script_execute(script, argument[1], argument[2], argument[3], argument[4], argument[5]);
        break;
    default: break; //will not accept more than 5 arguments
}
