
// Ujistí se, že je fullscreen zapnutý
if (window_get_fullscreen() != fullscreen_enabled) {
    window_set_fullscreen(fullscreen_enabled);
}

// Klávesy pro pohyb nahoru/dolů
var pressed_down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
var pressed_up   = keyboard_check_pressed(vk_up)   || keyboard_check_pressed(ord("W"));

// Klávesy doleva/doprava pro změnu
var pressed_left = keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"));
var pressed_right = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));

// Potvrzení a zrušení
var confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("Z"));
var cancel = keyboard_check_pressed(vk_escape);

if (menu_state == "main") {
    if (pressed_down) {
        menu_selected = (menu_selected + 1) mod menu_max;
    }
    if (pressed_up) {
        menu_selected = (menu_selected - 1 + menu_max) mod menu_max;
    }

            if (confirm) {
        switch (menu_selected) {
            case 0:  // NEW GAME nebo CONTINUE
                if (menu_items[0] == "NEW GAME") {
                    show_debug_message("=== STARTING NEW GAME ===");
                    
                    // Resetuj všechno
                    global.player_x = 0;
                    global.player_y = 0;
                    global.player_hp = 0;
                    global.current_wave = 0;
                    global.wave_active = false;
                    global.enemies_spawned = 0;
                    global.enemies_killed = 0;
                    
                    room_goto(Room_level1);
                    
                 } else {
    // CONTINUE
    show_debug_message("=== CONTINUE SELECTED ===");
    
    global.load_game = true; 
    
    global.game_paused = false;
    
    if (variable_global_exists("last_room") && global.last_room != Omenu) {
        room_goto(global.last_room);
    } else {
        room_goto(Room_level1);
    }
}
                break;
                
            case 1:  // SETTINGS
                menu_state = "settings";
                settings_selected = 0; 
                break;
            case 2:  // CONTROLS
                menu_state = "controls";
                break;
            case 3:  // EXIT
                game_end();
                break;
        }
    }
    if (cancel) {
        game_end();
    }
}
else if (menu_state == "settings") {
    if (pressed_down) {
        settings_selected = (settings_selected + 1) mod settings_max;
    }
    if (pressed_up) {
        settings_selected = (settings_selected - 1 + settings_max) mod settings_max;
    }

    // VOLUME
    if (settings_selected == 0) {
        if (pressed_left && master_volume > 0) {
            master_volume -= 5;
            if (master_volume < 0) master_volume = 0;
            audio_master_gain(master_volume / 100); 
        }
        if (pressed_right && master_volume < 100) {
            master_volume += 5;
            if (master_volume > 100) master_volume = 100;
            audio_master_gain(master_volume / 100);
        }
    }

    // RESOLUTION
    if (settings_selected == 1) {
        if (pressed_left && current_resolution > 0) {
            current_resolution -= 1;
            window_set_size(resolution_w[current_resolution], resolution_h[current_resolution]);
        }
        if (pressed_right && current_resolution < 2) {
            current_resolution += 1;
            window_set_size(resolution_w[current_resolution], resolution_h[current_resolution]);
        }
    }

    // FULLSCREEN
    if (settings_selected == 2) {
        if (confirm) {
            fullscreen_enabled = !fullscreen_enabled;
            window_set_fullscreen(fullscreen_enabled);
        }
    }
    
    if (cancel) {
        menu_state = "main";
    }
}
else if (menu_state == "controls") {
    if (cancel) {
        menu_state = "main";
    }
}