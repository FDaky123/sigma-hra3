if (variable_global_exists("load_game") && global.load_game == true) {
    show_debug_message("=== OPLAYER: LOADING STATS ===");
    
    // 1. Pozice
    if (variable_global_exists("player_x")) x = global.player_x;
    if (variable_global_exists("player_y")) y = global.player_y;
    
    // 2. Základní stats
    if (variable_global_exists("player_hp")) hp = global.player_hp;
    if (variable_global_exists("player_money")) money = global.player_money;
    
    // 3. Zbraně
    if (variable_global_exists("saved_current_weapon")) current_weapon = global.saved_current_weapon;
    if (variable_global_exists("saved_weapon_unlocked")) weapon_unlocked = global.saved_weapon_unlocked;

    // 4. Combat Statistiky (To co ti chybělo)
    if (variable_global_exists("saved_damage_dealt")) total_damage_dealt = global.saved_damage_dealt;
    if (variable_global_exists("saved_damage_taken")) total_damage_taken = global.saved_damage_taken;
    if (variable_global_exists("saved_enemies_killed")) total_enemies_killed = global.saved_enemies_killed;
    if (variable_global_exists("saved_shots_fired")) total_shots_fired = global.saved_shots_fired;
    if (variable_global_exists("saved_shots_hit")) total_shots_hit = global.saved_shots_hit;

    // 5. Pohyb a Casino
    if (variable_global_exists("saved_jumps")) total_jumps = global.saved_jumps;
    if (variable_global_exists("saved_dashes")) total_dashes = global.saved_dashes;
    if (variable_global_exists("saved_money_earned")) total_money_earned = global.saved_money_earned;
    
    if (variable_global_exists("saved_casino_spins")) casino_slots_spins = global.saved_casino_spins;
    if (variable_global_exists("saved_casino_won")) casino_total_won = global.saved_casino_won;
    if (variable_global_exists("saved_casino_spent")) casino_total_spent = global.saved_casino_spent;
    
}