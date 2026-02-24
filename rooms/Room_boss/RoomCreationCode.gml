// ========== BOSS ROOM SETUP ==========
show_debug_message("=== BOSS ROOM LOADED ===");

// SPAWN PLAYER U DVEŘÍ
if (instance_exists(Oplayer) && instance_exists(Odoor_shop)) {
    Oplayer.x = Odoor_shop.x + 32 ;
    Oplayer.y = Odoor_shop.y - 15;
    Oplayer.vel_x = 0;
    Oplayer.vel_y = 0;
    show_debug_message("Player spawned at door: " + string(Oplayer.x) + ", " + string(Oplayer.y));
}

// SPAWN BOSS VLEVO (mimo obrazovku)
if (!instance_exists(Oboss)) {
    var boss_spawn_x = 250;  // Daleko vlevo
    var boss_spawn_y = 580;  // Ground level
    
    var boss = instance_create_layer(boss_spawn_x, boss_spawn_y, "Instances", Oboss);
}

// ========== SPAWN BOSS UI ========== ← DŮLEŽITÉ
if (!instance_exists(Oboss_ui)) {
    instance_create_layer(0, 0, "Instances", Oboss_ui);
    show_debug_message("Boss UI spawned");
}

// Lock door
if (instance_exists(Odoor_shop)) {
    Odoor_shop.locked_during_boss = true;
}