// Ignoruj pokud je boss mrtvý
if (other.is_dead) {
    instance_destroy();
    exit;
}

// Ignoruj pokud je boss nezranitelný
if (other.invincible_timer > 0) {
    instance_destroy();
    exit;
}

// DAMAGE
var damage_dealt = damage;
other.hp -= damage_dealt;

// ========== PLAYER STATISTIKY ==========
if (instance_exists(Oplayer)) {
    Oplayer.total_shots_hit++;
    Oplayer.total_damage_dealt += damage_dealt;
}

// Flash effect
other.flash_timer = 10;
other.invincible_timer = other.invincible_duration;

// Destroy projectile
instance_destroy();