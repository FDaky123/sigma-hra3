// objects/Owave_manager/Create_0.gml
depth = -1000;
persistent = true;

// =========================================================
// 1. DEFINICE FUNKCÍ
// =========================================================

function shuffle_rooms() {
    var n = array_length(available_rooms);
    for (var i = n - 1; i > 0; i--) {
        var j = irandom(i);
        var temp = available_rooms[i];
        available_rooms[i] = available_rooms[j];
        available_rooms[j] = temp;
    }
    current_room_index = 0;
    used_rooms = [];
}

function get_next_random_room() {
    if (current_room_index >= array_length(available_rooms)) shuffle_rooms();
    var next_room = available_rooms[current_room_index];
    array_push(used_rooms, next_room);
    current_room_index++;
    return next_room;
}

// === TOTO ZDE CHYBĚLO A ZPŮSOBOVALO CRASH ===
function get_enemy_type_for_wave() {
    var wave = current_wave;
    // Vlna 1: pouze základní
    if (wave <= 1) return "basic";
    // Vlna 2: základní + shooter
    else if (wave == 2) {
        if (random(100) < 70) return "basic";
        else return "shooter";
    }
    // Vlna 3: mix
    else if (wave == 3) {
        var rand = random(100);
        if (rand < 40) return "basic";
        else if (rand < 60) return "shooter";
        else if (rand < 80) return "flying";
        else return "jumper";
    }
    // Vlna 4+: vše
    else {
        var rand = random(100);
        if (rand < 25) return "basic";
        else if (rand < 50) return "shooter";
        else if (rand < 75) return "flying";
        else return "jumper";
    }
}
// ============================================

function spawn_enemy() {
    var spawner_count = instance_number(Ospawner);
    if (spawner_count <= 0) return noone;
    
    var random_spawner = instance_find(Ospawner, irandom(spawner_count - 1));
    if (!instance_exists(random_spawner)) return noone;
    
    // Tady se volá Ospawner, který zpětně volá get_enemy_type_for_wave
    return random_spawner.spawn_enemy();
}

function start_wave() {
    // Cleanup
    instance_destroy(Oenemy);
    instance_destroy(Oenemy_flying);
    instance_destroy(Oenemy_jumper);
    instance_destroy(Oenemy_shooter);
    
    enemies_alive = 0;
    enemies_spawned = 0;
    
    current_wave++;
    global.current_wave = current_wave;
    
    var wave_index = min(current_wave - 1, array_length(wave_config) - 1);
    var config = wave_config[wave_index];
    
    enemies_to_spawn = config.enemies;
    wave_active = true;
    wave_complete = false;
    spawn_timer = spawn_delay;
    
    // POJISTKA PROTI "NEXT WAVE IN 1"
    auto_start_timer = 0; 
    
    show_debug_message("=== WAVE " + string(current_wave) + " STARTED ===");
}

// =========================================================
// 2. PROMĚNNÉ A NASTAVENÍ
// =========================================================

available_rooms = [
    Room_level1, Room_level2, Room_level3, Room_level4, 
    Room_level5, Room_level6, Room_level7, Room_level8, Room_level9
];
current_room_index = 0;
used_rooms = [];
randomize();
shuffle_rooms();

wave_config = [
    { enemies: 10, money_drop: 10 },
    { enemies: 15, money_drop: 15 },
    { enemies: 20, money_drop: 20 },
    { enemies: 25, money_drop: 25 },
    { enemies: 30, money_drop: 30 }
];

enemy_types = [Oenemy, Oenemy_flying, Oenemy_jumper, Oenemy_shooter];

if (!variable_global_exists("current_wave")) global.current_wave = 1;
if (!variable_global_exists("boss_room_unlocked")) global.boss_room_unlocked = false;

boss_room_unlocked = false;
boss_fight_active = false;

// Proměnné
spawn_delay = 60;
spawn_timer = 0;

auto_start_timer = 0;   
auto_start_delay = 120; 

enemies_alive = 0;
enemies_spawned = 0;
enemies_to_spawn = 0;

current_wave = 0; 
wave_active = false;
wave_complete = false;