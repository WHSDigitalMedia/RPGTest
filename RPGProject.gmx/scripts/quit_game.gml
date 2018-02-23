#define quit_game
///quit_game()
game_end();

#define start_game
///start_game()
with (instance_create(0, 0, fx_screenFade)) {
    targetRoom = rm_main_room;
}