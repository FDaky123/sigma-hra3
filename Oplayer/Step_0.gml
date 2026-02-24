// ========== DEATH CHECK - MUSÍ BÝT PRVNÍ! ==========
if (hp <= 0 && !is_dead) {
    is_dead = true;
    hp = 0;
    
    // Visual effects
    repeat(15) {
        var particle_x = x + random_range(-30, 30);
        var particle_y = y + random_range(-30, 30);
    }
    
    // Reset money
    money = 0;
    global.player_money = 0;
    global.current_wave = 0;
    
    // Statistics
    deaths++;
    
    // OKAMŽITÝ RESTART - BEZ ALARMU
    game_restart();
    exit;
}

// Stop processing pokud je mrtvý
if (is_dead) {
    vel_x = 0;
    vel_y = 0;
    exit;
}

// ========== PAUSE FREEZE ==========
if (global.game_paused) {
    vel_x = 0;
    vel_y = 0;
    exit;
}

// ========== FREEZE KDYŽ JE CASINO OTEVŘENÉ ==========
if (instance_exists(Ocasino_manager) && Ocasino_manager.casino_active) {
    vel_x = 0;
    vel_y = 0;
    exit;
}

// ========== BOSS CONTACT COOLDOWN ==========
if (boss_contact_cd > 0) {
    boss_contact_cd--;
}

// ========== KNOCKBACK ==========
if (knockback_timer > 0) {
    knockback_timer--;
    
    if (knockback_timer <= 0) {
        is_knockback = false;
    }
}

if (invincible_timer > 0) {
    invincible_timer--;
}

// Pokud je knockback, SKIP všechny inputy
if (is_knockback) {
    vel_y += gravity_force;
    if (vel_y > max_fall_speed) {
        vel_y = max_fall_speed;
    }
    
    vel_x *= 0.88;
    
    if (place_meeting(x + vel_x, y, Oground)) {
        while (!place_meeting(x + sign(vel_x), y, Oground)) {
            x += sign(vel_x);
        }
        vel_x = 0;
    }
    x += vel_x;

    if (place_meeting(x, y + vel_y, Oground)) {
        while (!place_meeting(x, y + sign(vel_y), Oground)) {
            y += sign(vel_y);
        }
        vel_y = 0;
    }
    y += vel_y;
    
    image_angle = 0;
    
    exit;  
}

// ========== KONTROLY ==========
var move_left = keyboard_check(ord("A")) || keyboard_check(vk_left);
var move_right = keyboard_check(ord("D")) || keyboard_check(vk_right);
var jump = keyboard_check_pressed(vk_space);
var sprint = keyboard_check(vk_shift);
var dash = keyboard_check_pressed(ord("F"));

var on_ground = place_meeting(x, y + 1, Oground);

// ========== DASH ==========
if (dash_cooldown_timer > 0) dash_cooldown_timer--;

if (dash && dash_cooldown_timer <= 0 && !is_dashing) {
    total_dashes++;
    is_dashing = true;
    dash_timer = dash_duration;
    dash_cooldown_timer = dash_cooldown;
}

if (is_dashing) {
    vel_x = dash_speed * facing;
    vel_y = 0;
    
    // GHOST TRAIL
    if (dash_timer % 3 == 0) {
        var particle = instance_create_depth(x, y, depth + 1, Oparticle);
        particle.sprite_index = sprite_index;
        particle.image_index = image_index;
        particle.image_xscale = facing;
        particle.particle_color = c_white;
        particle.vel_x = 0;
        particle.vel_y = 0;
        particle.gravity_force = 0;
        particle.lifetime = 15;
        particle.max_lifetime = 15;
        particle.fade_out = true;
        particle.is_sprite = true;
    }
    
    // EXTRA PARTICLES
    repeat(2) {
        var particle = instance_create_depth(
            x + random_range(-10, 10), 
            y + random_range(-sprite_height/2, sprite_height/2), 
            depth - 1, 
            Oparticle
        );
        particle.particle_color = choose(c_white, c_yellow, c_ltgray);
        particle.vel_x = -facing * random_range(1, 3);
        particle.vel_y = random_range(-1, 1);
        particle.gravity_force = 0;
        particle.lifetime = 10;
        particle.max_lifetime = 10;
        particle.image_xscale = random_range(0.5, 1.0);
        particle.fade_out = true;
    }
    
    dash_timer--;
    if (dash_timer <= 0) {
        is_dashing = false;
    }
}

// ========== POHYB ==========
if (!is_dashing && !is_knockback) {
    is_sprinting = sprint;
    var current_speed = move_speed;
    if (is_sprinting) {
        current_speed *= sprint_multiplier;
    }
    
    vel_x = 0;
    
    if (move_left) {
        vel_x = -current_speed;
        facing = -1;
    }
    else if (move_right) {
        vel_x = current_speed;
        facing = 1;
    }
    
    // ========== WALL DETECTION ==========
    on_wall = 0;
    if (place_meeting(x + 1, y, Oground) && !on_ground) {
        on_wall = -1;
    }
    if (place_meeting(x - 1, y, Oground) && !on_ground) {
        on_wall = 1;
    }
    
    // ========== WALL SLIDE ==========
    if (on_wall != 0 && vel_y > 0) {
        vel_y = wall_slide_speed;
    } else {
        vel_y += gravity_force;
        if (vel_y > max_fall_speed) {
            vel_y = max_fall_speed;
        }
    }
    
    // ========== RESET JUMPS ==========
    if (on_ground || on_wall != 0) {
        jumps_remaining = max_jumps;
    }

    // ========== JUMP / DOUBLE JUMP ==========
if (jump && jumps_remaining > 0) {
    vel_y = -jump_force;
    total_jumps++;
    jumps_remaining--;
    
    // DOUBLE JUMP EFFECT (jen pro 2. a další skok)
    if (jumps_remaining < max_jumps - 1) {
        // HORIZONTÁLNÍ ŽLUTÁ ČÁRA
        for (var i = -30; i <= 30; i += 3) {
            var particle = instance_create_depth(x + i, y + sprite_height/2, depth - 1, Oparticle);
            particle.particle_color = c_white;
            particle.vel_x = 0;
            particle.vel_y = random_range(0.5, 2);
            particle.gravity_force = 0.1;
            particle.lifetime = 15;
            particle.max_lifetime = 15;
            particle.image_xscale = 1.0;
            particle.fade_out = true;
        }
    }
}

    // ========== WALL JUMP ==========
if (jump && on_wall != 0) {
    vel_y = -wall_jump_force_y;
    vel_x = wall_jump_force_x * on_wall;
    facing = sign(on_wall);
    jumps_remaining = max_jumps - 1;
    
    // WALL JUMP EFFECT - NA STRANĚ KDE SE DÍVÁŠ
    var wall_side_x = x - (facing * 16);  // OPAČNÁ STRANA OD FACINGU
    repeat(8) {
        var particle = instance_create_depth(wall_side_x, y + random_range(-20, 20), depth - 1, Oparticle);
        particle.particle_color = c_white;
        particle.vel_x = facing * random_range(1, 3);  // SMĚR PODLE FACINGU
        particle.vel_y = random_range(-3, 3);
        particle.gravity_force = 0.3;
        particle.lifetime = 15;
        particle.max_lifetime = 15;
        particle.image_xscale = 0.8;
        particle.fade_out = true;
    }
    
    on_wall = 0;
	}
}

// ========== KOLIZE X ==========
if (place_meeting(x + vel_x, y, Oground)) {
    while (!place_meeting(x + sign(vel_x), y, Oground)) {
        x += sign(vel_x);
    }
    vel_x = 0;
}

x += vel_x;
x = round(x);

// ========== KOLIZE Y ==========
if (place_meeting(x, y + vel_y, Oground)) {
    while (!place_meeting(x, y + sign(vel_y), Oground)) {
        y += sign(vel_y);
    }
    vel_y = 0;
}

y += vel_y;
y = round(y);

// ========== WEAPON SWITCHING ==========
if (keyboard_check_pressed(ord("1"))) {
    if (weapon_unlocked[0]) current_weapon = 0;
}
if (keyboard_check_pressed(ord("2"))) {
    if (weapon_unlocked[1]) current_weapon = 1;
}
if (keyboard_check_pressed(ord("3"))) {
    if (weapon_unlocked[2]) current_weapon = 2;
}
if (keyboard_check_pressed(ord("4"))) {
    if (weapon_unlocked[3]) current_weapon = 3;
}
if (keyboard_check_pressed(ord("5"))) {
    if (weapon_unlocked[4]) current_weapon = 4;
}

// ========== AIM DIRECTION (4 SMĚRY - JEN WASD) ==========
var aim_up = keyboard_check(ord("W")) || keyboard_check(vk_up);
var aim_down = keyboard_check(ord("S")) || keyboard_check(vk_down);
var aim_left = keyboard_check(ord("A")) || keyboard_check(vk_left);
var aim_right = keyboard_check(ord("D")) || keyboard_check(vk_right);

// 4 směry (jen kardinální)
if (aim_up) {
    aim_direction = 90;
} else if (aim_down) {
    aim_direction = -90;
} else if (aim_left) {
    aim_direction = 180;
} else if (aim_right) {
    aim_direction = 0;
} else {
    aim_direction = (facing == 1) ? 0 : 180;
}

// ========== COMBAT - CASINO WEAPONS ==========
if (attack_cooldown > 0) {
    attack_cooldown--;
}

if ((keyboard_check_pressed(ord("Z")) || mouse_check_button_pressed(mb_left)) && attack_cooldown <= 0) {
    total_shots_fired++;
    
    var weapon = global.weapons[current_weapon];
    
    // === PLAYING CARDS ===
    if (current_weapon == 0) {
        var bullet = instance_create_depth(x, y, depth, Oprojectile);
        bullet.sprite_index = weapon.projectile_sprite;
        bullet.direction = aim_direction;
        bullet.speed = weapon.speed;
        bullet.damage = weapon.damage;
        bullet.image_angle = bullet.direction;
        bullet.owner = id;
        bullet.weapon_type = "card";
    }
    
    // === POKER CHIPS (Explosion) ===
    else if (current_weapon == 1) {
        var bullet = instance_create_depth(x, y, depth, Oprojectile);
        bullet.sprite_index = weapon.projectile_sprite;
        bullet.direction = aim_direction;
        bullet.speed = weapon.speed;
        bullet.damage = weapon.damage;
        bullet.image_angle = bullet.direction;
        bullet.owner = id;
        bullet.weapon_type = "chip";
        bullet.explosion_radius = weapon.explosion_radius;
    }
    
    // === LUCKY DICE (Shotgun) ===
    else if (current_weapon == 2) {
        var spread = weapon.spread;
        var count = weapon.projectile_count;
        
        for (var i = 0; i < count; i++) {
            var bullet = instance_create_depth(x, y, depth, Oprojectile);
            bullet.sprite_index = weapon.projectile_sprite;
            var angle_offset = -spread/2 + (spread / (count-1)) * i;
            bullet.direction = aim_direction + angle_offset;
            bullet.speed = weapon.speed;
            bullet.damage = weapon.damage;
            bullet.image_angle = bullet.direction;
            bullet.owner = id;
            bullet.weapon_type = "dice";
        }
    }
    
    // === ROULETTE (Random damage) ===
    else if (current_weapon == 3) {
        var bullet = instance_create_depth(x, y, depth, Oprojectile);
        bullet.sprite_index = weapon.projectile_sprite;
        bullet.direction = aim_direction;
        bullet.speed = weapon.speed;
        bullet.damage = irandom_range(weapon.damage_min, weapon.damage_max);
        bullet.image_angle = bullet.direction;
        bullet.owner = id;
        bullet.weapon_type = "roulette";
        
        show_debug_message("Roulette Damage: " + string(bullet.damage));
    }
    
    // === SLOT MACHINE (Jackpot chance) ===
    else if (current_weapon == 4) {
        var spread = weapon.spread;
        var count = weapon.projectile_count;
        var jackpot = (random(1) < weapon.jackpot_chance);
        
        for (var i = 0; i < count; i++) {
            var bullet = instance_create_depth(x, y, depth, Oprojectile);
            bullet.sprite_index = weapon.projectile_sprite;
            var angle_offset = -spread/2 + (spread / (count-1)) * i;
            bullet.direction = aim_direction + angle_offset;
            bullet.speed = weapon.speed;
            
            if (jackpot) {
                bullet.damage = weapon.jackpot_damage;
                bullet.image_blend = c_yellow;
            } else {
                bullet.damage = weapon.damage;
            }
            
            bullet.image_angle = bullet.direction;
            bullet.owner = id;
            bullet.weapon_type = "slot";
        }
        
        if (jackpot) {
            show_debug_message("🎰 JACKPOT! 🎰");
        }
    }
    
    attack_cooldown = weapon.fire_rate;
}

// ========== SPIKE DAMAGE ==========
if (spike_immunity > 0) {
    spike_immunity--;
}

if (place_meeting(x, y, Ospike) && spike_immunity <= 0 && invincible_timer <= 0) {
    hp -= 10;
    total_damage_taken += 10;
    spike_immunity = 60;
    
    var spike = instance_place(x, y, Ospike);
    if (spike != noone) {
        var knockback_dir = point_direction(spike.x, spike.y, x, y);
        vel_x = lengthdir_x(knockback_force * 1.5, knockback_dir);
        vel_y = -5;
        
        is_knockback = true;
        knockback_timer = 15;
        invincible_timer = invincible_duration;
    }
    
    show_debug_message("SPIKE DAMAGE! HP: " + string(hp));
}

// ========== PENÍZE PERSISTENCE ==========
global.player_money = money;