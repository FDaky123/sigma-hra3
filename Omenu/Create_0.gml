// ========== INICIALIZACE GLOBÁLNÍCH PROMĚNNÝCH ==========
if (!variable_global_exists("player_x")) {
    global.player_x = 0;
}
if (!variable_global_exists("player_y")) {
    global.player_y = 0;
}
if (!variable_global_exists("player_hp")) {
    global.player_hp = 0;
}
if (!variable_global_exists("last_room")) {
    global.last_room = Omenu;
}
if (!variable_global_exists("game_paused")) {
    global.game_paused = false;
}

// ========== OMENU - CREATE ==========
menu_selected = 0;
menu_state = "main"

// Nastavení
master_volume = 75;
fullscreen_enabled = true;

// Rozlišení
resolution_list = ["1280x720", "1920x1080", "2560x1440"];
current_resolution = 1
resolution_w = [1280, 1920, 2560];
resolution_h = [720, 1080, 1440];

settings_selected = 0;
settings_max = 3

// Fullscreen
window_set_fullscreen(fullscreen_enabled);
window_set_size(resolution_w[current_resolution], resolution_h[current_resolution]);

// Kontrola jestli má být CONTINUE nebo NEW GAME
has_saved_game = false;

if (variable_global_exists("player_x") && variable_global_exists("player_y")) {
    if (global.player_x != 0 || global.player_y != 0) {
        has_saved_game = true;
    }
}

if (has_saved_game) {
    menu_items = ["CONTINUE", "SETTINGS", "CONTROLS", "EXIT"];
} else {
    menu_items = ["NEW GAME", "SETTINGS", "CONTROLS", "EXIT"];
    
    // JENOM PŘI PRVNÍM STARTU - smaž všechno
    with (all) {
        if (object_index != Omenu) {
            instance_destroy();
        }
    }
}

menu_max = array_length(menu_items);

// 1. Resetuje velikost GUI vrstvy na plné HD (aby texty nebyly obří)
display_set_gui_size(1920, 1080);

// 2. Vypne všechny herní kamery (viewports)
for (var i = 0; i < 8; i++) {
    view_enabled[i] = false;
    view_visible[i] = false;
}

// 3. Ujistí se, že "plátno" hry má správnou velikost (pokud se změnilo)
surface_resize(application_surface, 1920, 1080);