// ========== BOSS COLLISION S HRÁČEM ==========
if (!instance_exists(other)) exit;

var player = other;

// ========== JUMP AERIAL ==========
if (state == "attack_jump" && is_jumping && !place_meeting(x, y + 1, Oground)) {
    if (!variable_instance_exists(id, "aerial_flag") || !aerial_flag) {
        player.hp -= 25;
        if (instance_exists(Oplayer)) {
            Oplayer.total_damage_taken += 25;
        }
        aerial_flag = true;
        
        if (variable_instance_exists(player, "vel_x")) {
            player.vel_x = direction_facing * 8;
            player.vel_y = -4;
        }
    }
}

// ========== JUMP SLAM ==========
if (state == "attack_jump" && place_meeting(x, y + 1, Oground) && state_timer >= 20 && state_timer <= 25) {
    var slam_dist = point_distance(x, y, player.x, player.y);
    if (slam_dist < 120) {
        if (!variable_instance_exists(id, "slam_flag") || !slam_flag) {
            player.hp -= 35;
            if (instance_exists(Oplayer)) {
                Oplayer.total_damage_taken += 35;
            }
            slam_flag = true;
            
            if (variable_instance_exists(player, "vel_x")) {
                var knock = sign(player.x - x);
                if (knock == 0) knock = 1;
                player.vel_x = knock * 10;
                player.vel_y = -6;
            }
        }
    }
}

if (state != "attack_jump") {
    if (variable_instance_exists(id, "aerial_flag")) aerial_flag = false;
    if (variable_instance_exists(id, "slam_flag")) slam_flag = false;
}

// ========== DASH ==========
if (state == "attack_dash" && is_dashing) {
    if (!variable_instance_exists(id, "dash_flag") || !dash_flag) {
        player.hp -= 30;
        if (instance_exists(Oplayer)) {
            Oplayer.total_damage_taken += 30;
        }
        dash_flag = true;
        
        if (variable_instance_exists(player, "vel_x")) {
            player.vel_x = direction_facing * 12;
            player.vel_y = -7;
        }
    }
}

if (state != "attack_dash" && variable_instance_exists(id, "dash_flag")) {
    dash_flag = false;
}

// ========== CONTACT DAMAGE ==========
if (state == "chase" || state == "idle") {
    if (!variable_instance_exists(player, "boss_contact_cd")) {
        player.boss_contact_cd = 0;
    }
    
    if (player.boss_contact_cd <= 0) {
        player.hp -= 25;
        if (instance_exists(Oplayer)) {
            Oplayer.total_damage_taken += 5;
        }
        
        if (variable_instance_exists(player, "vel_x")) {
            var knock = sign(player.x - x);
            if (knock == 0) knock = 1;
            player.vel_x = knock * 5;
            player.vel_y = -3;
        }
        
        player.boss_contact_cd = 30;
    }
}

// Knockback
var knockback_dir = point_direction(x, y, other.x, other.y);
other.vel_x = lengthdir_x(other.knockback_force, knockback_dir);
other.vel_y = lengthdir_y(other.knockback_force, knockback_dir) - 3;

other.is_knockback = true;
other.knockback_timer = 10;
other.invincible_timer = other.invincible_duration;