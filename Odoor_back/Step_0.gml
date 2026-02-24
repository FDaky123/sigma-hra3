var pl = instance_nearest(x, y, Oplayer);

// ========== CASINO CHECK ==========
if (instance_exists(Ocasino_manager) && Ocasino_manager.casino_active) {
    show_prompt = false;
    exit;
}
	
if (pl != noone) {
    var in_hitbox = (pl.x >= x && 
                     pl.x <= x + hitbox_width &&
                     pl.y >= y && 
                     pl.y <= y + hitbox_height);
    
    if (in_hitbox) {
        prompt = true;
        
        if (keyboard_check_pressed(ord("E"))) {
            
            // ========== NÁVRAT PO BOSS FIGHTU → WAVE 6 ==========
            if (variable_global_exists("returning_from_boss") && global.returning_from_boss) {
                show_debug_message("=== Returning from boss shop - Starting Wave 6! ===");
                
                global.returning_from_boss = false;
                global.returning_from_shop = true;
                global.came_from_shop = true;
                
                // Nastaví Wave 6
                if (instance_exists(Owave_manager)) {
                    Owave_manager.current_wave = 5;  // Bude 6 po start_wave()
                    global.current_wave = 5;
                    Owave_manager.boss_room_unlocked = false;
                    Owave_manager.boss_fight_active = false;
                }
                
                // Reset shop door flag
                with (Odoor_shop) {
                    boss_defeated_flag = false;
                }
                
                if (variable_global_exists("return_room")) {
                    room_goto(global.return_room);
                } else {
                    room_goto(Room_level1);
                }
                return;
            }
            
            global.returning_from_shop = true;
            global.came_from_shop = true;
            
            // ========== BOSS SYSTEM CHECK ==========
            if (instance_exists(Owave_manager)) {
                // První vstup do boss room (po wave 4)
                if (Owave_manager.boss_room_unlocked && !Owave_manager.boss_fight_active) {
                    show_debug_message("=== ENTERING BOSS ROOM ===");
					global.boss_room_entry = true;
                    room_goto(Room_boss);
                    return;
                }
                // Návrat během boss fightu
                else if (Owave_manager.boss_fight_active) {
                    show_debug_message("Returning to boss fight...");
                    room_goto(Room_boss);
                    return;
                }
            }
            
				 // ========== NORMÁLNÍ NÁVRAT ==========
				show_debug_message(">>> RETURNING TO GAME <<<");
				global.came_from_shop = true;

					// Získej DALŠÍ random roomku
				if (instance_exists(Owave_manager)) {
					var next_room = Owave_manager.get_next_random_room();
					room_goto(next_room);
				} else {
					// Fallback
					room_goto(Room_level1);
				}
        }
    } else {
        prompt = false;
    }
} else {
    prompt = false;
}