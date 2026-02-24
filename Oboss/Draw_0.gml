// Flash effect při damage
if (flash_timer > 0) {
    if (flash_timer % 4 < 2) {
        draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_red, 1);
    } else {
        draw_self();
    }
} else {
    draw_self();
}

// ========== MELEE CHARGING EFFECT ==========
if (state == "attack_melee" && melee_windup < melee_windup_max) {
    var charge_percent = melee_windup / melee_windup_max;
    
    var hitbox_width = 250;
    var hitbox_height = 150;
    
    draw_set_alpha(0.3 + (charge_percent * 0.4));
    draw_set_color(c_red);
    draw_rectangle(x - hitbox_width/2, y - hitbox_height/2, x + hitbox_width/2, y + hitbox_height/2, false);
    
    draw_set_alpha(0.6);
    draw_set_color(c_orange);
    draw_rectangle(x - hitbox_width/2, y - hitbox_height/2, x + hitbox_width/2, y + hitbox_height/2, true);
    
    draw_set_alpha(1);
}

// ========== MELEE STRIKE EFFECT ==========
if (state == "attack_melee" && melee_windup >= melee_windup_max) {
    var effect_alpha = 1;
    if (melee_windup > melee_windup_max) {
        effect_alpha = 1 - ((melee_windup - melee_windup_max) / 10);
    }
    
    if (effect_alpha > 0) {
        var hitbox_width = 250;
        var hitbox_height = 150;
        
        var hitbox_left = x - hitbox_width/2;
        var hitbox_right = x + hitbox_width/2;
        var hitbox_top = y - hitbox_height/2;
        var hitbox_bottom = y + hitbox_height/2;
        
        draw_set_alpha(0.5 * effect_alpha);
        draw_set_color(c_red);
        draw_rectangle(hitbox_left, hitbox_top, hitbox_right, hitbox_bottom, false);
        
        draw_set_alpha(0.9 * effect_alpha);
        draw_set_color(c_orange);
        draw_rectangle(hitbox_left, hitbox_top, hitbox_right, hitbox_bottom, true);
        draw_rectangle(hitbox_left - 2, hitbox_top - 2, hitbox_right + 2, hitbox_bottom + 2, true);
        draw_rectangle(hitbox_left - 4, hitbox_top - 4, hitbox_right + 4, hitbox_bottom + 4, true);
        
        for (var i = 0; i < 8; i++) {
            var angle = i * 45;
            var line_length = 60 * effect_alpha;
            var start_x = x;
            var start_y = y;
            var end_x = start_x + lengthdir_x(line_length, angle);
            var end_y = start_y + lengthdir_y(line_length, angle);
            
            draw_set_color(c_yellow);
            draw_line_width(start_x, start_y, end_x, end_y, 4);
        }
    }
    
    draw_set_alpha(1);
}

// Dash effect
if (is_dashing) {
    draw_set_alpha(0.5);
    draw_sprite_ext(sprite_index, image_index, x - (direction_facing * 20), y, image_xscale, image_yscale, image_angle, c_orange, 0.5);
    draw_set_alpha(1);
}

draw_set_color(c_white);
draw_set_alpha(1);