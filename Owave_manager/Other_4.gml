// ========== AUTO-CREATE OHUD ==========
if (!instance_exists(Ohud)) {
    instance_create_depth(0, 0, -9999, Ohud);
    show_debug_message(">>> Ohud auto-created in " + room_get_name(room));
}

// Pokud se vracíme z obchodu, automaticky spusť další vlnu
if (variable_global_exists("came_from_shop") && global.came_from_shop) {
    show_debug_message("Returned from shop - starting next wave!");
    show_debug_message("Current room: " + room_get_name(room));
    
    // Počkej chvíli než začne vlna (aby hráč měl čas)
    auto_start_timer = 90;  // 3 sekundy delay
    wave_complete = false;
    
    // Reset flagu
    global.came_from_shop = false;
} else {
    // Normální room start
    current_wave = global.current_wave;
    
    // AUTO-START vlny (pokud ještě nebyla spuštěna)
    if (current_wave == 0) {
        auto_start_timer = auto_start_delay;
        wave_active = false;
        wave_complete = false;
    }
}

// Reset spawn hodnot
enemies_to_spawn = 0;
enemies_spawned = 0;
enemies_alive = 0;
spawn_timer = spawn_delay;

// objects/Owave_manager/Other_4.gml

if (instance_number(Ospawner) == 0) exit;

var should_load = false;
if (variable_global_exists("load_game") && global.load_game == true) {
    should_load = true;
}

if (should_load) {
    // ========== LOAD GAME ==========
    show_debug_message("=== WAVE MANAGER: RESUMING WAVE ===");
    
    // 1. Základní data
    if (variable_global_exists("current_wave_saved")) current_wave = global.current_wave_saved;
    else current_wave = 1;
    
    if (variable_global_exists("enemies_to_spawn_saved")) enemies_to_spawn = global.enemies_to_spawn_saved;
    
    // Pojistka configu
    if (enemies_to_spawn == 0) {
        var idx = clamp(current_wave - 1, 0, array_length(wave_config) - 1);
        enemies_to_spawn = wave_config[idx].enemies;
    }

    // 2. CHYTRÉ OBNOVENÍ NEPŘÁTEL
    // Načteme kolik jich bylo celkem naspawnováno
    var saved_spawned = 0;
    if (variable_global_exists("enemies_spawned_saved")) saved_spawned = global.enemies_spawned_saved;
    
    // Načteme kolik jich bylo naživu při uložení
    var saved_alive = 0;
    if (variable_global_exists("enemies_alive_saved")) saved_alive = global.enemies_alive_saved;
    
    // MATEMATIKA: "Vrátíme čas" o počet živých nepřátel.
    // Tím donutíme hru, aby ty chybějící (co se zničili při odchodu) naspawnovala znovu.
    enemies_spawned = max(0, saved_spawned - saved_alive);
    
    show_debug_message("Spawned: " + string(saved_spawned) + " | Alive: " + string(saved_alive) + " -> New Counter: " + string(enemies_spawned));

    // 3. Aktivita vlny
    if (variable_global_exists("wave_active_saved") && global.wave_active_saved == true) {
        wave_active = true;
        auto_start_timer = 0; 
        spawn_timer = 30; // Začni spawnovat rychle (půl vteřiny)
    } else {
        wave_active = false;
        auto_start_timer = 120;
    }
    
    alarm[0] = 1; 

} else {
    // ========== NEW GAME ==========
    if (current_wave == 0) {
        show_debug_message("=== WAVE MANAGER: INSTANT START ===");
        global.current_wave = 1;
        start_wave(); 
        auto_start_timer = 0;
    }
}