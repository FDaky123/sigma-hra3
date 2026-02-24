// ========== SMRT ==========
if (hp <= 0 && !is_dead) {
    is_dead = true;
    
    // ========== PLAYER STATISTIKA - KILL ==========
    if (instance_exists(Oplayer)) {
        Oplayer.total_enemies_killed++;
        Oplayer.total_bosses_killed++;  // ← PŘIDEJ TUHLE PROMĚNNOU
    }
    
    repeat(30) {
        var explosion_x = x + random_range(-80, 80);
        var explosion_y = y + random_range(-80, 80);
    }
    
    global.boss_defeated = true;
    
    repeat(15) {
        var money = instance_create_layer(
            x + random_range(-100, 100), 
            y - random_range(0, 80), 
            "Instances", 
            Omoney
        );
        money.value = 150;
    }
    
    with (Odoor_shop) {
        locked_during_boss = false;
        boss_defeated_flag = true;
    }
    
    if (instance_exists(Owave_manager)) {
        Owave_manager.boss_fight_active = false;
    }
    
    instance_destroy();
    exit;
}

// ========== PHASE CHECK ==========
var hp_percent = hp / max_hp;

if (hp_percent <= phase_3_threshold && current_phase < 3) {
    current_phase = 3;
    attack_cooldown_max = 60;
    move_speed = 3.5;
    dash_speed = 18;
    jump_cooldown_max = 60;
    show_debug_message("BOSS PHASE 3 - ENRAGED!");
}
else if (hp_percent <= phase_2_threshold && current_phase < 2) {
    current_phase = 2;
    attack_cooldown_max = 75;
    move_speed = 3;
    dash_speed = 16;
    jump_cooldown_max = 70;
    show_debug_message("BOSS PHASE 2 - AGGRESSIVE!");
}

// ========== GROUND CHECK ==========
var on_ground = place_meeting(x, y + 1, Oground);

// ========== GRAVITACE ==========
if (!on_ground && !is_dashing) {
    vel_y += gravity_force;
    if (vel_y > max_fall_speed) {
        vel_y = max_fall_speed;
    }
} else if (on_ground) {
    vel_y = 0;
    
    // Reset jump když přistaneš
    if (is_jumping && state == "attack_jump") {
        is_jumping = false;
    }
}

// ========== COOLDOWNS ==========
if (attack_cooldown > 0) attack_cooldown--;
if (jump_cooldown > 0) jump_cooldown--;
if (invincible_timer > 0) invincible_timer--;
if (flash_timer > 0) flash_timer--;

// ========== MELEE STRIKE EFFECT TIMER ==========
if (melee_strike_effect_timer > 0) {
    melee_strike_effect_timer--;
}

// ========== AI ==========
if (instance_exists(target)) {
    var dist = point_distance(x, y, target.x, target.y);
    
    // Směr k hráči
    if (target.x < x) {
        direction_facing = -1;
    } else {
        direction_facing = 1;
    }
    
    state_timer++;
    
    switch(state) {
        case "idle":
            vel_x = 0;
            
            if (dist < detection_range) {
                state = "chase";
                state_timer = 0;
                show_debug_message("Boss: IDLE → CHASE");
            }
            break;
        
        case "chase":
            vel_x = move_speed * direction_facing;
            
            // Edge check
            if (on_ground) {
                var edge_check_x = x + (direction_facing * 40);
                var edge_check_y = y + 20;
                
                if (!place_meeting(edge_check_x, edge_check_y, Oground)) {
                    vel_x = 0;
                }
            }
            
            // ========== ATTACK DECISION ==========
            if (attack_cooldown <= 0) {
                var vertical_dist = abs(target.y - y);
                
                // MELEE ATTACK (blízko)
                if (dist <= melee_range && on_ground && vertical_dist < 100) {
                    state = "attack_melee";
                    state_timer = 0;
                    melee_windup = 0;
                    vel_x = 0;
                    show_debug_message("Boss: CHASE → MELEE ATTACK");
                }
                // JUMP ATTACK (střední vzdálenost nebo hráč výš)
                else if (dist > melee_range && dist <= 600 && jump_cooldown <= 0 && on_ground && (vertical_dist > 80 || random(100) < 25)) {
                    state = "attack_jump";
                    state_timer = 0;
                    is_jumping = true;
                    vel_y = -jump_force;
                    jump_cooldown = jump_cooldown_max;
                    show_debug_message("Boss: CHASE → JUMP ATTACK");
                }
                // DASH ATTACK (střední vzdálenost)
                else if (dist > melee_range && dist <= 500 && on_ground && random(100) < 35) {
                    state = "attack_dash";
                    state_timer = 0;
                    is_dashing = true;
                    dash_duration = 0;
                    vel_y = 0;
                    show_debug_message("Boss: CHASE → DASH ATTACK");
                }
                // SHOTGUN ATTACK (dálka)
                else if (dist > melee_range && dist <= attack_range) {
                    state = "attack_shotgun";
                    state_timer = 0;
                    vel_x = 0;
                    show_debug_message("Boss: CHASE → SHOTGUN ATTACK");
                }
                // RAPID FIRE (phase 2+)
                else if (dist > melee_range && dist <= attack_range) {
                    state = "attack_rapid";
                    state_timer = 0;
                    rapid_fire_count = 0;
                    rapid_fire_timer = 0;
                    vel_x = 0;
                    show_debug_message("Boss: CHASE → RAPID FIRE");
                }
            }
            break;
        
        case "attack_melee":
    vel_x = 0;
    melee_windup++;
    
    // WIND-UP - třes a charging efekt
    if (melee_windup < melee_windup_max) {
        if (melee_windup % 3 == 0) {
            x += choose(-2, 2);
        }
    }
    
    // STRIKE! - AKTIVUJ VISUAL EFEKT
    if (melee_windup == melee_windup_max) {
        melee_strike_effect_timer = 15;  // Ukaž efekt na 15 frames
        show_debug_message("BOSS MELEE STRIKE!");
    }
    
    if (state_timer >= 40) {
        state = "chase";
        state_timer = 0;
        attack_cooldown = attack_cooldown_max;
        show_debug_message("Boss: MELEE → CHASE");
    }
    break;
        
        case "attack_jump":
            // Horizontal movement během skoku
            vel_x = move_speed * direction_facing * 2;
            
            // Když přistaneš - JEN VISUAL, damage je v Oplayer collision
            if (on_ground && state_timer > 20) {
                // VISUAL EFFECT - SHOCKWAVE
                repeat(20) {
                    var particle_angle = random(360);
                    var particle_dist = random_range(30, 120);
                    var particle_x = x + lengthdir_x(particle_dist, particle_angle);
                    var particle_y = y;
                }
                
                show_debug_message("BOSS JUMP SLAM!");
                
                state = "chase";
                state_timer = 0;
                attack_cooldown = attack_cooldown_max / 2;
                is_jumping = false;
                show_debug_message("Boss: JUMP → CHASE");
            }
            break;
        
        case "attack_dash":
            if (is_dashing) {
                dash_duration++;
                
                // Dash movement
                vel_x = dash_speed * direction_facing;
                vel_y = 0;
                
                
                // End dash
                if (dash_duration >= dash_duration_max) {
                    is_dashing = false;
                    vel_x = 0;
                }
            }
            
            if (state_timer >= 50) {
                state = "chase";
                state_timer = 0;
                attack_cooldown = attack_cooldown_max;
                is_dashing = false;
                show_debug_message("Boss: DASH → CHASE");
            }
            break;
        
        case "attack_shotgun":
            vel_x = 0;
            
            if (state_timer == 25) {
                var base_angle = point_direction(x, y - 32, target.x, target.y);
                var spread = shotgun_spread_angle;
                
                for (var i = 0; i < shotgun_projectile_count; i++) {
                    var angle = base_angle - (spread / 2) + (spread / (shotgun_projectile_count - 1)) * i;
                    
                    var bullet = instance_create_layer(x + (direction_facing * 30), y - 32, "Instances", Oenemy_projectile);
                    bullet.direction = angle;
                    bullet.speed = 10;
                    bullet.damage = 15;
                    bullet.image_angle = angle;
                }
                
                show_debug_message("BOSS SHOTGUN BLAST!");
            }
            
            if (state_timer >= 50) {
                state = "chase";
                state_timer = 0;
                attack_cooldown = attack_cooldown_max;
                show_debug_message("Boss: SHOTGUN → CHASE");
            }
            break;
        
        case "attack_rapid":
            vel_x = 0;
            rapid_fire_timer++;
            
            // Střílej každých X frames
            if (rapid_fire_timer >= rapid_fire_delay && rapid_fire_count < rapid_fire_max) {
                var angle = point_direction(x, y - 32, target.x, target.y);
                angle += random_range(-10, 10);
                
                var bullet = instance_create_layer(x + (direction_facing * 30), y - 32, "Instances", Oenemy_projectile);
                bullet.direction = angle;
                bullet.speed = 12;
                bullet.damage = 12;
                bullet.image_angle = angle;
                
                rapid_fire_count++;
                rapid_fire_timer = 0;
                show_debug_message("RAPID FIRE: " + string(rapid_fire_count) + "/" + string(rapid_fire_max));
            }
            
            if (rapid_fire_count >= rapid_fire_max && state_timer >= rapid_fire_max * rapid_fire_delay + 20) {
                state = "chase";
                state_timer = 0;
                attack_cooldown = attack_cooldown_max;
                rapid_fire_timer = 0;
                show_debug_message("Boss: RAPID FIRE → CHASE");
            }
            break;
    }
    
} else {
    state = "idle";
    vel_x = 0;
}

// ========== MELEE HITBOX CHECK ==========
if (state == "attack_melee" && instance_exists(target)) {
    if (melee_windup >= melee_windup_max && melee_windup <= melee_windup_max + 10) {
        var hitbox_width = 250;
        var hitbox_height = 150;
        
        var hitbox_left = x - hitbox_width/2;
        var hitbox_right = x + hitbox_width/2;
        var hitbox_top = y - hitbox_height/2;
        var hitbox_bottom = y + hitbox_height/2;
        
        var player_in_hitbox = (target.bbox_right >= hitbox_left && 
                                target.bbox_left <= hitbox_right &&
                                target.bbox_bottom >= hitbox_top && 
                                target.bbox_top <= hitbox_bottom);
        
        if (player_in_hitbox) {
            if (!variable_instance_exists(id, "melee_hit_flag") || !melee_hit_flag) {
                target.hp -= melee_damage;
                if (instance_exists(Oplayer)) {
                    Oplayer.total_damage_taken += melee_damage;
                }
                melee_hit_flag = true;
                
                if (variable_instance_exists(target, "vel_x")) {
                    var knock_dir = sign(target.x - x);
                    if (knock_dir == 0) knock_dir = 1;
                    target.vel_x = knock_dir * 12;
                    target.vel_y = -7;
                }
            }
        }
    }
}

if (state != "attack_melee" && variable_instance_exists(id, "melee_hit_flag")) {
    melee_hit_flag = false;
}

// ========== DAMAGE FROM PLAYER ==========
if (invincible_timer <= 0) {
    var bullet = instance_place(x, y, Oprojectile);
    if (bullet != noone) {
        hp -= bullet.damage;
        flash_timer = 5;
        invincible_timer = invincible_duration;
        
        instance_destroy(bullet);
        
        show_debug_message("Boss hit! HP: " + string(hp) + "/" + string(max_hp));
    }
    
    if (place_meeting(x, y, Oplayer)) {
        hp -= 10;
        flash_timer = 5;
        invincible_timer = invincible_duration * 2;
        
        show_debug_message("Boss melee hit! HP: " + string(hp));
    }
}

// ========== KOLIZE X ==========
if (place_meeting(x + vel_x, y, Oground)) {
    while (!place_meeting(x + sign(vel_x), y, Oground)) {
        x += sign(vel_x);
    }
    vel_x = 0;
    
    if (is_dashing) {
        is_dashing = false;
    }
}

x += vel_x;

// ========== KOLIZE Y ==========
if (place_meeting(x, y + vel_y, Oground)) {
    while (!place_meeting(x, y + sign(vel_y), Oground)) {
        y += sign(vel_y);
    }
    vel_y = 0;
}

y += vel_y;

// ========== SPRITE FLIP ==========
if (direction_facing == -1) {
    image_xscale = -2;
} else {
    image_xscale = 2;
}

// ========== DAMAGE FROM SPIKES ==========
if (place_meeting(x, y, Ospike)) {
    hp -= 25;
}