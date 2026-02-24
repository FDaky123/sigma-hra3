// Ignoruj pokud je hráč nezranitelný
if (other.invincible_timer > 0) {
    instance_destroy();
    exit;
}

// Vezmi damage
var projectile_damage = damage;
other.hp -= projectile_damage;
other.total_damage_taken += projectile_damage;

// Knockback
var knockback_dir = point_direction(x, y, other.x, other.y);
other.vel_x = lengthdir_x(other.knockback_force, knockback_dir);
other.vel_y = lengthdir_y(other.knockback_force, knockback_dir) - 3;

other.is_knockback = true;
other.knockback_timer = 10;
other.invincible_timer = other.invincible_duration;

// Zničení projektilu
instance_destroy();

// Smrt
if (other.hp <= 0) {
    other.hp = 0;
    global.current_wave = 0;
    global.player_money = 0;
    game_restart();
}