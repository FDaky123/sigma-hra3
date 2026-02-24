
// ========== BOSS STATS ==========
hp = 1000;
max_hp = 1000;
is_dead = false;
damage = 20;

// Movement
move_speed = 2.5;
vel_x = 0;
vel_y = 0;
gravity_force = 0.5;
max_fall_speed = 10;
direction_facing = 1;

// ========== AI STATES ==========
state = "idle";
state_timer = 0;

// Detection
target = Oplayer;
detection_range = 2000;
attack_range = 600;
melee_range = 150;

// ========== ATTACK TIMERS ==========
attack_cooldown = 0;
attack_cooldown_max = 90;

// DASH ATTACK
dash_speed = 15;
dash_duration = 0;
dash_duration_max = 20;
is_dashing = false;

// JUMP ATTACK
jump_force = 12;
jump_cooldown = 0;
jump_cooldown_max = 80;
is_jumping = false;

// MELEE ATTACK
melee_damage = 40;
melee_windup = 0;
melee_windup_max = 20;
melee_hitbox_width = 120;      // ← PŘIDEJ
melee_hitbox_height = 100;     // ← PŘIDEJ
melee_hitbox_offset_x = 80;    // ← PŘIDEJ
melee_hitbox_offset_y = -20;   // ← PŘIDEJ
melee_strike_effect_timer = 0; // ← PŘIDEJ

// SHOTGUN ATTACK
shotgun_projectile_count = 12;
shotgun_spread_angle = 80;

// RAPID FIRE
rapid_fire_count = 0;
rapid_fire_max = 5;
rapid_fire_delay = 8;
rapid_fire_timer = 0;

// ========== PHASE SYSTEM ==========
current_phase = 1;
phase_2_threshold = 0.66;
phase_3_threshold = 0.33;

// ========== INVINCIBILITY ==========
invincible_timer = 0;
invincible_duration = 10;

// ========== VISUAL ==========
flash_timer = 0;

// ========== ENTRANCE ==========
entrance_target_x = 0;
entrance_complete = false;
entrance_speed = 3;
