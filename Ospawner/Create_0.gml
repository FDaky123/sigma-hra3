// Spawn effect timer
spawn_effect_timer = 0;
spawn_effect_duration = 30;

// Spawner - spawn point pro nepřátele

// Spawn effect timer
spawn_effect_timer = 0;
spawn_effect_duration = 30;

// Spawn funkce
function spawn_enemy() {
    if (!instance_exists(Owave_manager)) {
        show_debug_message("ERROR: Owave_manager doesn't exist!");
        return noone;
    }
    
    // Získej typ nepřítele
    var enemy_type = Owave_manager.get_enemy_type_for_wave();
    var enemy = noone;
    
    // Vytvoř enemy
    switch(enemy_type) {
        case "basic":
            enemy = instance_create_layer(x, y, "Instances", Oenemy);
            break;
            
        case "jumper":
            enemy = instance_create_layer(x, y, "Instances", Oenemy_jumper);
            break;
            
        case "shooter":
            // Check jestli už není shooter na platformě
            var occupied = false;
            with (Oenemy_shooter) {
                if (point_distance(x, y, other.x, other.y) < 200) {
                    occupied = true;
                    break;
                }
            }
            
            if (occupied) {
                enemy = instance_create_layer(x, y, "Instances", Oenemy);
                enemy_type = "basic";
            } else {
                enemy = instance_create_layer(x, y, "Instances", Oenemy_shooter);
            }
            break;
            
        case "flying":
            enemy = instance_create_layer(x, y, "Instances", Oenemy_flying);
            break;
    }
    
    // Wave scaling
    if (instance_exists(enemy)) {
        var wave = Owave_manager.current_wave;
        var hp_mult = 1 + ((wave - 1) * 0.15);
        var dmg_mult = 1 + ((wave - 1) * 0.15);
        
        enemy.max_hp = floor(enemy.max_hp * hp_mult);
        enemy.hp = enemy.max_hp;
        enemy.damage = floor(enemy.damage * dmg_mult);
        
        // Speed variance
        var base_speed = enemy.move_speed;
        var variance = random_range(0.85, 1.15);
        var wave_bonus = 1 + ((wave - 1) * 0.05);
        enemy.move_speed = base_speed * variance * wave_bonus;
        
        spawn_effect_timer = spawn_effect_duration;
        
        show_debug_message(">>> Spawned " + enemy_type);
    }
    
    return enemy;
}