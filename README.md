# GameMaker RPG Engine Documentation
WHS Digital Media Club, 2017-18

* Created by Jason Jewik
* Email: [jason.jewik@gmail.com](mailto:jason.jewik@gmail.com)
* Website: [jj11d7t.github.io](https://jj11d7t.github.io)

## Project Overview and Table of Contents
_**This project was created as a starting engine for future RPG games.**_ It is recommended to have the game project open while going through this documentation.

#### 1. [Player](#player)
* Moves in only the cardinal directions, using WASD and defaulting to the last pressed key
* Can interact with NPCs and the environment by pressing E
#### 2. [Buttons](#buttons)
* Perform action on mouse over/exit/click
* Align text to center, left, or right (or no text)
* Single use or multi use
#### 3. [Textboxes](#textboxes)
* Pauses the game, creating a panel overlay
* Individual textboxes draw on top of the panel with the speaker's sprite displayed to the left or right (alternating)
* Textboxes fade in one at a time
* Automatically inserts line breaks
* Displays responses that can be selected using the number keys
* Pulls text, responses, response actions, and sprites from external INI file
#### 4. [NPCs](#NPCs)
* Has four movement types: completely still, still but alternates directions, random movement, and back-forth linear motion
* Interacts with the player (can be set to with toggle or without toggle)
* Holds variables that point to the location of their corresponding INI file for textboxes (see above)
* Has two modes: default mode (for moving and interacting with player) and controller mode (for creating textboxes)
#### 5. [Pause](#pause)
* Creates a blurred sprite from the current game view
* Sets the sprite as the new background and disables all other objects
* Draws over the blurred screen
#### 6. [Doors/Map](#Doors/Map)
* Doors have two modes: default and map
* Doors can also be locked or unlocked
* In default mode, the player has to walk over doors to toggle
* In map mode, the player has to click on doors to toggle, and they display the name of their target location
* The map screen draws a blinking player sprite over the door representing their current location
#### 7. [Items/Inventory](#Items/Inventory)
* The inventory is actually comprised of four lists: consumables, equippables, miscellaneous, and currently equipped
* The lists can be set to sort in alphabetical order ascending or descending
* The currently equipped list is always displayed, buttons are used to toggle the display between the remaining three
* Item data is actually stored externally in an INI file
* Items can affect multiple stats, have a description, type, subtype, and cost (all stored in the INI file)
#### 8. [Camera](#Camera)
* The camera has three modes: none, fixed, and track (the player)
#### 9. [Combat](#Combat)
* Currently in progress
#### 9. [Important Notes](#important-notes)

## Player
#### Create Event
```
///Initialize Variables 
name = "Flan";

moveSpeed = 2;
allowMovement = true;
allowInput = true;

UP = ord("W");
LEFT = ord("A");
DOWN = ord("S");
RIGHT = ord("D");

ATK = 0;
DEF = 1;
SPD = 2;
ACC = 3;
HP = 4;

stat[ATK] = 10;
stat[DEF] = 10;
stat[SPD] = 10;
stat[ACC] = 10;
stat[HP] = 10;

statLevelCap = 50;
```

#### Explanation of Variables
Note that this explanation will only cover variables whose purpose may not be readily apparent.
* **allowMovement** determines whether the player can move with WASD.
* **allowInput** determines whether player inputs will be interpreted at all.

#### Horizontal Movement Collision Code
```
//horizontal collisions
	if (place_meeting(x + xMove, y, class_solid)) {
    	var xInc = sign(xMove);
        while (!place_meeting(x + xInc, y, class_solid)) {
			x += xInc;
		} 
		xMove = 0;
	}
x += xMove;
```
This checks to see if the player's position plus its movement speed would put the player in contact with a solid object. If so, while the player is not one pixel away from the solid, he will move forward one pixel at a time. Once he is one pixel away from the solid, *xMove* is overriden to say 0 to prevent moving into the wall.

## Buttons
#### Create Event
```
text = "";
textColor = c_black;
textAlpha = 1;
textFont = fnt_arial16;
textXPos = 0;
textYPos = 0;

LEFT = 0;
CENTER = 1;
RIGHT = 2;
textAlign = CENTER;

INIT_OVER = 0;
END_OVER = 1;
INIT_EXIT = 2;
END_EXIT = 3;
mouseStatus = END_EXIT;
overAction = noone;
leaveAction = noone;
clickAction = noone;

SINGLE_USE = 0;
MULTI_USE = 1;
mode = MULTI_USE;
done = false;
```

#### Explanation of Variables
Note that this explanation will only cover variables whose purpose may not be readily apparent.

* **overAction** should store the script to run when the mouse is over the button.
* **leaveAction** should store the reciprocal script to run when the mouse leaves the button (typically this will just undo whatever the *overAction* script does).
* **clickAction** should store the script to run when the left mouse button is clicked.
* **mode** determines whether the button can be pressed only once or multiple times. For instance, if you have a button that starts the game and there's a fade out delay, you don't want the player to mash the "start game" button over and over.
* **done** is only useful if *mode* is set to *MULTI_USE*. If *mode = MULTI_USE* and the button is clicked, *done* will be set to true to prevent the button from running the *clickAction* script again.
* **textXPos/textYPos** can be used to offset the text's draw location relative to the origin of the assigned sprite.


## Textboxes
#### Create Event
```
///Initialize Variables
text = "";
textFont = fnt_arial16;
textColor = c_black;
spr = -1;

rad = 4;
outlineColor = c_black;
boxColor = c_white;
padding = 8;

LEFT = 0;
RIGHT = 1;
CENTER = 2;
orientation = LEFT;
order = 0;

myAlpha = 0;
fadeDuration = global.textAppearDelay;
fadeSpeed = 1/fadeDuration;
done = false;

//these vars here are all set in the step event
height = 0;
x1 = 0;
y1 = 0;
x2 = 0;
y2 = 0;
width = 0;
```

#### Explanation of Variables
Note that this explanation will only cover variables whose purpose may not be readily apparent.

* **orientation** refers to the text alignment. Of course, this doesn't matter if the *text* variable is left blank.
* **order** is the order in which this textbox will appear on the chat screen. It does not matter what it is set to here since it will be manually overriden by the calling *class_npc* object.
* **text** is what the textbox will say. Once again, literally not important because it is set by the calling *class_npc* object.


## NPCs
#### Create Event
```
///Initialize Variables
STILL = 0;
RANDOM_LOOK = 1;
RANDOM_WALK = 2;
FORWARD_BACK = 3;
moveType = FORWARD_BACK;

//random walk motion
randomTime = random_range(2 * room_speed, 4 * room_speed);
xTarg = x;
yTarg = y;
moveSpeed = 2;
deadband = 2;
maxDist = 64;
alarm_set(0, -1);

//forward back motion
initX = x;
finalX = x + 64;
initY = y;
finalY = y;
FORWARD = 0;
BACKWARD = 1;
dir = FORWARD;

//talking to the player
triggerDist = 32;
INIT_TRIGGER = 0;
CURRENT_TRIGGER = 1;
END_TRIGGER = 2;
triggerStatus = END_TRIGGER;
goFirst = false; //whether the player has to press 'e'

//mode
DEFAULT = 0;
CONTROLLER = 1;
mode = DEFAULT;

//text location
textFile = "npc_1_main_room.ini";
directory = working_directory + "Text_Interactions\NPC_1\";
textSource = directory + textFile;
textSection = "default";
sprSection = "default-sprites";
responseSection = "default-responses";
scriptSection = "default-scripts";
argumentSection = "default-arguments";
textCreated = false;
responsesCreated = false;
/* IMPORTANT NOTE
* all responses' keys must come after 
* the text keys in the INI file
*/
```

#### Explanation of Variables
Note that this explanation will only cover variables whose purpose may not be readily apparent.

* **mode** is used to determine what the NPC's behavior should be. If it set to *DEFAULT*, then the NPC is in the overworld and can move around and interact with the player. If it set to *CONTROLLER*, then the NPC is currently in *rm_text_interaction* and it is creating the textboxes to be used.
* **text location variables** all refer to the INI file where the text interactions are saved.
* **textCreated** refers to whether or not the textboxes have been created. Only applicable if the current room is *rm_text_interaction*.
* **responsesCreated** refers to whether or not the responses have been created. Only applicable if the current room is *rm_text_interaction*.

## Pause
#### Create Event
```
///Initialize Variables
global.UNPAUSE = 0;
global.STANDARD_PAUSE = 1;
global.TEXT_PAUSE = 2;
global.MAP_PAUSE = 3;
global.INVENTORY_PAUSE = 4;
global.pause = global.UNPAUSE;

intensity = 0.7; //the blur intensity
steps = 3; //also affects intensity but it's better to change the above value
draw = false; //has the sprite been created
roomIndex = rm_main_room; //room to return to
spr = -1; //the sprite the surface will draw
```
#### Explanation of Variables
Note that this explanation will only cover variables whose purpose may not be readily apparent.

* **global pause variables** denote the possible types of pauses
	* *global.UNPAUSE* is for when the game is not paused
	* *global.STANDARD_PAUSE* means the player is on the pause screen
	* *global.TEXT_PAUSE* means the player is talking with an NPC or a textbox is open somehow
	* *global.MAP_PAUSE* means the player is on the map screen
	* *global.INVENTORY_PAUSE* means the player is on the inventory screen
	* In all of these instances, we want at least some aspect of the game to pause (i.e. we don't want the player to still move around, or even be visible, when on the inventory screen).
* **intensity/steps** are related to how the screen blurs. I actually don't really remember exactly how these work (I first learned how to create a screen blur from a tutorial provided by YoYoGames but have long forgotten exactly how it works), but it works well, so do not touch them unless you figured out how to use them.
* **draw** just refers to whether or not we want to draw the blurred background stored in *spr*

## Doors/Map
#### Create Event of *class_door*
```
///Initialize Variables
roomTarg = -1;
name = "";
xTarg = 0;
yTarg = 0;
lock = false;

DEFAULT = 0;
MAP = 1;
mode = DEFAULT;
```
#### Explanation of Variables
Note that this explanation will only cover variables whose purpose may not be readily apparent.

* **name** refers to what text the door will display when *mode = MAP*

#### Snippet of Step Event of *class_door*
```
with (instance_create(x, y, fx_screenFade)) {
	targetRoom = other.roomTarg;
    xTarg = other.xTarg;
    yTarg = other.yTarg;
    mode = ROOM_TRANSITION;
}
```
The door itself is not actually what moves the player. It transfers its variables' data to the *fx_screenFade* object because we only want the player to "move" when the screen is completely blacked out, at which point the door has already stopped existing as an object.

#### Draw Event of *controller_map*
```
///Draw the player sprite
for (var i = 0; i < instance_number(class_door); i++) {
    var inst = instance_find(class_door, i);
    if (inst.roomTarg == controller_pause.roomIndex) {
        draw_sprite(spr_player, 0, inst.x, inst.y);
        i = instance_number(class_door);
    }
}
```
This code loops through all existing door objects and checks to see if their variable *roomTarg* matches the variable *roomIndex* of *controller_pause*. The pause controller's room index refers to the room that we want to go back to when we unpause, and the door's target room refers to the room that door leads to. Therefore, if they are the same, that door is the room the player just came from and that's where we should draw the player sprite.

## Items/Inventory
#### Create Event of *controller_inventory*
```
///Initialize Variables
equippableList = ds_list_create();
equippableMax = 10;
consumableList = ds_list_create();
consumableMax = 10;
miscList = ds_list_create();
miscMax = 10;
list[0] = equippableList;
list[1] = consumableList;
list[2] = miscList;

equippedList = ds_list_create();

ASCENDING = true;
DESCENDING = false;
sortOrientation = ASCENDING;

EQUIPPABLE = 0;
CONSUMABLE = 1;
MISCELLANEOUS = 2;
viewMode = EQUIPPABLE;

buttonsCreated = false;
```

#### Explanation of Variables
Note that this explanation will only cover variables whose purpose may not be readily apparent.
* **the list variables** point to three distinct data structure lists (ds_list) for each item type. We store those in an array for easy looping through later.
* **equippedList** is kept separate because it will have different functionality than the others.
* **viewMode** refers to which section of the inventory is currently open for the player to see.
* **buttonsCreated** is used to determine whether or not the inventory needs to rebuild buttons, which each correspond to an item in the currently selected list. This is useful so that the inventory does not infinitely create buttons and break itself. This is also useful because when we sort the inventory alphabetically, the buttons do not automatically update. Therefore, we can destroy all the old ones and tell the inventory controller that the buttons need to be re-created.

## Camera
#### Create Event
```
///Initialize Variables
NONE = 0;
FIXED = 1; 
TRACK = 2;
mode = TRACK;

xTarg = x;
yTarg = y;

view_width = 640;
view_height = 360;
```
#### Explanation of Variables
Note that this explanation will only cover variables whose purpose may not be readily apparent.
* **xTarg/yTarg** refer to the location the camera is focused on. If *mode = TRACK*, then these variables are automatically set to the player's position. For *mode = FIXED*, these variables can be set from the Creation Code. After the camera controller is placed in a room, right-click to access a drop-down menu, one option of which is "Creation Code", which runs after the object's "Creation Event", and can thus be used to override values.

## Combat

#### Coming soon! (Hopefully...)

## Important Notes
### 1. Variables
Variables in all-caps are considered _final_ variables, meaning they should never be changed during gameplay. They are often used for state-machines that runs a switch-case on the variables, so it technically does not matter, but they still should not be changed anyway. For example, below are snippets of code from *class_textbox*.
#### Create Event of *class_textbox*
```
INIT_OVER = 0;
END_OVER = 1;
INIT_EXIT = 2;
END_EXIT = 3;
mouseStatus = END_EXIT;
overAction = noone;
leaveAction = noone;
clickAction = noone;
```
#### Step Event of *class_textbox*
```
switch (mouseStatus) {
        case INIT_OVER: 
            if (script_exists(overAction)) {
                script_execute(overAction);
            }
            mouseStatus = END_OVER;
            break;
        case INIT_EXIT:
            if (script_exists(leaveAction)) {
                script_execute(leaveAction);
            }
            mouseStatus = END_EXIT;
            break;
        default: break;
}
```
These final variables use the "mixed case" naming convention (i.e. *INIT_OVER*), whereas all other standard variables use the "camel case" naming convention (i.e. *mouseStatus*).

### 2. INI Files
When dealing with INI files, it is _**HIGHLY**_ important that the variable holding the file location points to the correct directory. Furthermore, always take care to close INI files that no longer need to be used, or bad things will happen. For starters, GameMaker only permits one INI file open for reading/writing at a time. Secondly, INI files left open may cause memory leaks which will slow down and eventually crash the game. Fun!

### 3. Rooms
* Make sure that the room speed is always set to 60 - this basically translates to 60 fps and makes everything so much smoother.
* All "overworld" rooms need to have *persistence* enabled. This means the room will stay the same even if the player leaves and comes back. Do NOT enable this for menu rooms.
* "Overworld" rooms need to have the three HUD buttons (pause, map, and inventory) and *controller_camera*. Since *controller_pause* and *controller_inventory* are persistent across all rooms (meaning they never really go away), only include them in the starting room. If they are placed in other "overworld" rooms, it may cause problems on account of duplicate objects.

### 4. Object Hierarchy
##### The code for this game is organized into *controllers*, *classes*, and everything else. 

**Controllers** are meant to handle every aspect of a particular game mechanic. For instance, see *controller_text*. This object is the one that actually does stuff to the *gui_textbox* objects via the [*with*](https://docs.yoyogames.com/source/dadiospice/002_reference/001_gml%20language%20overview/401_18_with.html) function. In short, that function allows object A to temporarily access the code of and do something "with" object B.

**Classes** are meant to be used to transfer variables and functions to similar objects. For instance, see *class_button*. This object has code that can serve as a framework for all possible buttons in this game. This is achieved through what GameMaker calls "parenting", which can be set from an object's default menu. However, you want to change _some_ variables to make each "child" object unique. To do that, write code something like this...
#### Create Event of *main_menu_start_button*
```
///Initialize Variables
event_inherited();
text = "Play Game!";

overAction = set_text_color_white;
leaveAction = set_text_color_black;
clickAction = start_game;

mode = SINGLE_USE;
```

The function *event_inherited()* copies the code over from the same event of the parent object. So in this case, *main_menu_start_button* inherits all of the default variables that were initialized in the Create Event of *class_button*. The other variables set after *event_inherited()* is called act as manual overrides specific to the "child" object. If there is no code event, the "child" object inherits the code of the "parent" object by default. For instance, *main_menu_start_button* has no Step Event code, it instead automatically inherits the Step Event of *class_button*.


### 5. Important Numbers
The following are important numbers to remember for the INI files.
#### Character stats
```
ATK = 0;
DEF = 1;
SPD = 2;
ACC = 3;
HP = 4;
```
#### Move types
```
SINGLE_ATTACK = 0;
ALL_ATTACK = 1;
SINGLE_HEAL = 2;
ALL_HEAL = 3;
SINGLE_BUFF = 4;
ALL_BUFF = 5;
```


