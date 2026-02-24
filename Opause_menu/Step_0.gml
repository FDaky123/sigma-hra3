if (room == Room_menu) {
    global.game_paused = false;
    instance_destroy(); // Pokud se sem dostaneme, znič se.
    exit;
}

// ESC = Toggle pause (ale NE když je casino!)
if (keyboard_check_pressed(vk_escape)) {
    // ========== OCHRANA PŘED ESC V CASINU! ==========
    if (instance_exists(Ocasino_manager) && Ocasino_manager.casino_active) {
        exit;
    }
    
    // Casino není aktivní - toggle pause normálně
    global.game_paused = !global.game_paused;
    
    if (global.game_paused) {
        show_debug_message("=== GAME PAUSED ===");
        
        // Zastav hru
        instance_deactivate_all(true);
        
        // Aktivuj důležité objekty
        instance_activate_object(Opause_menu);
        instance_activate_object(Ohud);
        instance_activate_object(Ogame_init);
        instance_activate_object(Oplayer);
        
        // ========== AKTIVUJ BOSS OBJEKTY (POKUD EXISTUJÍ) ==========
        if (instance_exists(Oboss)) {
            instance_activate_object(Oboss);
        }
        if (instance_exists(Oboss_ui)) {
            instance_activate_object(Oboss_ui);
        }
        
        // Aktivuj wave manager
        if (instance_exists(Owave_manager)) {
            instance_activate_object(Owave_manager);
        }
        
    } else {
        show_debug_message("=== GAME RESUMED ===");
        // Aktivuj vše zpátky
        instance_activate_all();
    }
}

// Pokud je pauza aktivní
if (global.game_paused) {
    // Navigace
    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
        selected--;
        if (selected < 0) selected = max_options;
    }
    
    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
        selected++;
        if (selected > max_options) selected = 0;
    }
    
    // Výběr
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
        switch (selected) {
                         

case 1:  // QUIT TO MENU
                show_debug_message("=== QUITTING TO MENU ===");
                
                // 1. ULOŽENÍ HRÁČE (VŠECHNY DATA)
                if (instance_exists(Oplayer)) {
                    // Základ
                    global.player_x = Oplayer.x;
                    global.player_y = Oplayer.y;
                    global.player_hp = Oplayer.hp;
                    global.player_money = Oplayer.money;
                    
                    // Zbraně (Pokud používáš systém zbraní)
                    global.saved_current_weapon = Oplayer.current_weapon;
                    global.saved_weapon_unlocked = Oplayer.weapon_unlocked;
                    
                    // --- BOJOVÉ STATISTIKY ---
                    global.saved_damage_dealt = Oplayer.total_damage_dealt;
                    global.saved_damage_taken = Oplayer.total_damage_taken;
                    global.saved_enemies_killed = Oplayer.total_enemies_killed;
                    global.saved_shots_fired = Oplayer.total_shots_fired;
                    global.saved_shots_hit = Oplayer.total_shots_hit;
                    
                    // --- POHYB A PENÍZE ---
                    global.saved_jumps = Oplayer.total_jumps;
                    global.saved_dashes = Oplayer.total_dashes;
                    global.saved_money_earned = Oplayer.total_money_earned;
                    
                    // --- CASINO STATISTIKY ---
                    global.saved_casino_spins = Oplayer.casino_slots_spins;
                    global.saved_casino_blackjack = Oplayer.casino_blackjack_hands;
                    global.saved_casino_roulette = Oplayer.casino_roulette_spins;
                    global.saved_casino_won = Oplayer.casino_total_won;
                    global.saved_casino_spent = Oplayer.casino_total_spent;
                    
                    show_debug_message("=== ALL STATS SAVED SUCCESSFULLY ===");
                }
                
                // 2. ULOŽENÍ VLNY
                if (instance_exists(Owave_manager)) {
                    global.current_wave_saved = Owave_manager.current_wave;
                    global.wave_active_saved = Owave_manager.wave_active;
                    global.enemies_spawned_saved = Owave_manager.enemies_spawned;
                    global.enemies_to_spawn_saved = Owave_manager.enemies_to_spawn;
                }
    room_goto(Room_menu);
    break;
        }
    }
}