// Zkontroluj jestli boss existuje
if (!instance_exists(Oboss)) {
    exit;
}

var boss = Oboss;

// Vypočítej HP percent
var hp_percent = boss.hp / boss.max_hp;
if (hp_percent < 0) hp_percent = 0;

// Pozice na obrazovce (GUI layer)
var bar_x = display_get_gui_width() / 2 - (hp_bar_width / 2);
var bar_y = 50;

// ========== POZADÍ BARU ==========
draw_set_alpha(0.7);
draw_set_color(c_black);
draw_rectangle(bar_x - 5, bar_y - 5, bar_x + hp_bar_width + 5, bar_y + hp_bar_height + 5, false);

// ========== ČERVENÝ BAR (prázdné HP) ==========
draw_set_alpha(1);
draw_set_color(c_red);
draw_rectangle(bar_x, bar_y, bar_x + hp_bar_width, bar_y + hp_bar_height, false);

// ========== ZELENÝ/ŽLUTÝ/ORANŽOVÝ BAR (aktuální HP) ==========
var hp_color = c_lime;
if (hp_percent <= 0.33) {
    hp_color = c_red;
} else if (hp_percent <= 0.66) {
    hp_color = c_orange;
}

draw_set_color(hp_color);
draw_rectangle(bar_x, bar_y, bar_x + (hp_bar_width * hp_percent), bar_y + hp_bar_height, false);

// ========== BORDER ==========
draw_set_color(c_white);
draw_rectangle(bar_x, bar_y, bar_x + hp_bar_width, bar_y + hp_bar_height, true);
draw_rectangle(bar_x - 1, bar_y - 1, bar_x + hp_bar_width + 1, bar_y + hp_bar_height + 1, true);

// ========== NASTAVENÍ FONTU ==========
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Použij pixel font
if (font_exists(fnt_pixel)) {
    draw_set_font(fnt_pixel);
} else {
    draw_set_font(-1);
}

// ========== TEXT - BOSS NAME ==========
draw_set_color(c_black);
draw_text(bar_x + (hp_bar_width / 2) + 2, bar_y - 30 + 2, "BOSS");

draw_set_color(c_red);
draw_text(bar_x + (hp_bar_width / 2), bar_y - 30, "BOSS");

// ========== HP ČÍSLA ==========
var hp_text = string(round(boss.hp)) + " / " + string(boss.max_hp);

draw_set_color(c_black);
draw_text(bar_x + (hp_bar_width / 2) + 2, bar_y + (hp_bar_height / 2) + 2, hp_text);

draw_set_color(c_white);
draw_text(bar_x + (hp_bar_width / 2), bar_y + (hp_bar_height / 2), hp_text);

// ========== PHASE INDICATOR ==========
var phase_text = "PHASE " + string(boss.current_phase);
var phase_color = c_white;

if (boss.current_phase == 2) phase_color = c_orange;
if (boss.current_phase == 3) phase_color = c_red;

draw_set_color(c_black);
draw_text(bar_x + (hp_bar_width / 2) + 2, bar_y + hp_bar_height + 28 + 2, phase_text);

draw_set_color(phase_color);
draw_text(bar_x + (hp_bar_width / 2), bar_y + hp_bar_height + 28, phase_text);

// ========== RESET ==========
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);