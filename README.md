# GameMaker RPG Engine Documentation
WHS Digital Media Club, 2017-18

* Created by Jason Jewik
* Email: [jason.jewik@gmail.com](mailto:jason.jewik@gmail.com)
* Website: [jj11d7t.github.io](https://jj11d7t.github.io)

## Project Overview and Table of Contents
_**This project was created as a starting engine for future RPG games.**_

#### 1. [Buttons](#buttons)
* Perform action on mouse over/exit/click
* Align text to center, left, or right (or no text)
* Single use or multi use
#### 2. [Textboxes](#textboxes)
* Pauses the game, creating a panel overlay
* Individual textboxes draw on top of the panel with the speaker's sprite displayed to the left or right (alternating)
* Textboxes fade in one at a time
* Automatically inserts line breaks
* Displays responses that can be selected using the number keys
* Pulls text, responses, response actions, and sprites from external INI file
#### 3. [NPCs](#NPCs)
* Has four movement types: completely still, still but alternates directions, random movement, and back-forth linear motion
* Interacts with the player (can be set to with toggle or without toggle)
* Holds variables that point to the location of their corresponding INI file for textboxes (see above)
* Has two modes: default mode (for moving and interacting with player) and controller mode (for creating textboxes)
#### 4. [Pause](#pause)
* Creates a blurred sprite from the current game view
* Sets the sprite as the new background and disables all other objects
* Draws over the blurred screen
#### 5. [Doors/Map](#Doors/Map)
* Doors have two modes: default and map
* Doors can also be locked or unlocked
* In default mode, the player has to walk over doors to toggle
* In map mode, the player has to click on doors to toggle, and they display the name of their target location
* The map screen draws a blinking player sprite over the door representing their current location
#### 6. [Items/Inventory](#Items/Inventory)
* The inventory is actually comprised of four lists: consumables, equippables, miscellaneous, and currently equipped
* The lists can be set to sort in alphabetical order ascending or descending
* The currently equipped list is always displayed, buttons are used to toggle the display between the remaining three
* Item data is actually stored externally in an INI file
* Items can affect multiple stats, have a description, type, subtype, and cost (all stored in the INI file)
#### 7. [Camera](#Camera)
* The camera has three modes: none, fixed, and track (the player)
#### 8. [Combat](#Combat)
* Currently in progress
#### 9. [Important Notes](#important-notes)

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


## Textboxes

## NPCs

## Pause

## Doors/Map

## Items/Inventory

## Camera

## Combat

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
These final variables use the "mixed case" naming convention (i.e. *INIT_OVER*), whereas all other standard variables use the "camel case" naming convention (i.e. *mouseOver*).

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




