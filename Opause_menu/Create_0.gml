// Pause menu controller
depth = -9999;
persistent = true;

// Pause menu init
selected = 0;
max_options = 1;

// Ujisti se že global.game_paused existuje
if (!variable_global_exists("game_paused")) {
    global.game_paused = false;
}