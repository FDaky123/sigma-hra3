// objects/Owave_manager/Step_0.gml

// =========================================================
// 1. SYNCHRONIZACE S HUDEM
// =========================================================
// Zajišťuje, že HUD vidí správné číslo.
if (current_wave > 0) {
    global.current_wave = current_wave;
} else {
    global.current_wave = 1; // Fallback, aby tam nebyla 0
}

// =========================================================
// 2. ODPOČET DO STARTU VLNY (Auto Start)
// =========================================================
// Pokud je timer 0 (což nastavujeme při startu), tento blok se přeskočí a hra nečeká.
if (auto_start_timer > 0) {
    auto_start_timer--;

    // Jakmile čas vyprší a vlna ještě neběží -> SPUSTIT VLNU
    if (auto_start_timer <= 0 && !wave_active) {
        start_wave();
    }
}

// =========================================================
// 3. LOGIKA BĚHEM VLNY (Spawnování & Konec)
// =========================================================
if (wave_active) {
    
    // --- A) SPAWNOVÁNÍ NEPŘÁTEL ---
    // Pokud jsme ještě nenaspawnovali plný počet pro tuto vlnu
    if (enemies_spawned < enemies_to_spawn) {
        spawn_timer--;
        
        if (spawn_timer <= 0) {
            // Zavoláme funkci pro spawn (definovanou v Create)
            var spawned_enemy = spawn_enemy();
            
            // Pokud se spawn povedl (existují spawneři)
            if (spawned_enemy != noone) {
                enemies_spawned++;
                spawn_timer = spawn_delay; // Reset časovače (např. 60 framů)
            }
        }
    }
    
    // --- B) KONTROLA KONCE VLNY ---
    // Pokud jsou všichni naspawnovaní, kontrolujeme, zda jsou mrtví
    else {
        // Spočítáme všechny živé nepřátele
        var count = instance_number(Oenemy) 
                  + instance_number(Oenemy_flying) 
                  + instance_number(Oenemy_jumper) 
                  + instance_number(Oenemy_shooter);
        
        // Pokud je 0, vlna je hotová
        if (count == 0) {
            show_debug_message("=== WAVE " + string(current_wave) + " COMPLETE ===");
            
            wave_active = false;
            
            // Nastavíme odpočet pro další vlnu (např. 2 sekundy = 120 framů)
            auto_start_timer = auto_start_delay; 
            
            // Příklad: Odemčení bosse po 4. vlně
            if (current_wave == 4) {
                global.boss_room_unlocked = true;
                show_debug_message("-> BOSS UNLOCKED!");
            }
        }
    }
}
