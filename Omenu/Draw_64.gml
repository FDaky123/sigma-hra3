// ========== OMENU - DRAW GUI (FONT FIX) ==========

gpu_set_texfilter(false);
draw_set_font(fnt_pixel);

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

// ZAROVNÁNÍ
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var font_fix_y = 40; 

// --- NASTAVENÍ BAREV ---
var c_box_bg = c_dkgray;   
var c_border = c_white;    
var c_sel    = c_yellow;   
var c_norm   = c_white;    

// ================= MAIN MENU =================
if (menu_state == "main") {
    
    // --- 1. NADPIS ---
    var title_w = 1100; 
    var title_h = 280; 
    var title_x = gui_w / 2 - title_w / 2;
    var title_y = gui_h * 0.19;

    draw_set_color(c_box_bg);
    draw_rectangle(title_x, title_y - title_h/2, title_x + title_w, title_y + title_h/2, false);
    draw_set_color(c_border);
    draw_rectangle(title_x, title_y - title_h/2, title_x + title_w, title_y + title_h/2, true);

    draw_set_color(c_yellow);
    draw_text_transformed(gui_w / 2, title_y + font_fix_y, "On The Edge", 7, 7, 0);


    // --- 2. POLOŽKY ---
    var menu_w = 800; 
    var menu_h = 560;
    var menu_x = gui_w / 2 - menu_w / 2;
    var menu_y = gui_h * 0.60;

    draw_set_color(c_box_bg);
    draw_rectangle(menu_x, menu_y - menu_h/2, menu_x + menu_w, menu_y + menu_h/2, false);
    draw_set_color(c_border);
    draw_rectangle(menu_x, menu_y - menu_h/2, menu_x + menu_w, menu_y + menu_h/2, true);

    var dist_y = 120;
    var total_h = (menu_max - 1) * dist_y;
    var start_y = menu_y - (total_h / 2);

    for (var i = 0; i < menu_max; i++) {
        var txt = menu_items[i];
        var yy = start_y + (i * dist_y);
        
        var is_selected = (i == menu_selected);
        
        if (is_selected) {
            draw_set_color(c_sel);
            draw_text_transformed(gui_w / 2, yy + font_fix_y, "> " + txt + " <", 4.5, 4.5, 0);
        } else {
            draw_set_color(c_norm);
            draw_text_transformed(gui_w / 2, yy + font_fix_y, txt, 2.5, 2.5, 0);
        }
    }

    // --- 3. FOOTER - OVLÁDÁNÍ MENU ---
    var footer_w = 950;
    var footer_h = 80;
    var footer_x = gui_w / 2 - footer_w / 2;
    var footer_y = gui_h - 100;

    draw_set_color(c_box_bg);
    draw_rectangle(footer_x, footer_y - footer_h/2, footer_x + footer_w, footer_y + footer_h/2, false);
    draw_set_color(c_border);
    draw_rectangle(footer_x, footer_y - footer_h/2, footer_x + footer_w, footer_y + footer_h/2, true);

    draw_set_color(c_white);
    var menu_ctrl_y = footer_y - 30;
    var menu_ctrl_scale = 1.5;
    
    draw_text_transformed(gui_w / 2, menu_ctrl_y + font_fix_y, "[W/S] Select   [ENTER] Confirm   [ESC] Exit", menu_ctrl_scale, menu_ctrl_scale, 0);
}

// ================= SETTINGS =================
else if (menu_state == "settings") {

    // --- 1. NADPIS ---
    var title_w = 1100; 
    var title_h = 280; 
    var title_x = gui_w / 2 - title_w / 2;
    var title_y = gui_h * 0.19;

    draw_set_color(c_box_bg);
    draw_rectangle(title_x, title_y - title_h/2, title_x + title_w, title_y + title_h/2, false);
    draw_set_color(c_border);
    draw_rectangle(title_x, title_y - title_h/2, title_x + title_w, title_y + title_h/2, true);

    draw_set_color(c_yellow);
    draw_text_transformed(gui_w / 2, title_y + font_fix_y, "Settings", 7, 7, 0);


    // --- 2. OBSAH ---
    var content_w = 800; 
    var content_h = 560; 
    var content_x = gui_w / 2 - content_w / 2;
    var content_y = gui_h * 0.60;

    draw_set_color(c_box_bg);
    draw_rectangle(content_x, content_y - content_h/2, content_x + content_w, content_y + content_h/2, false);
    draw_set_color(c_border);
    draw_rectangle(content_x, content_y - content_h/2, content_x + content_w, content_y + content_h/2, true);

    // -- VOLUME --
    var vol_y = content_y - 120;
    var is_vol = (settings_selected == 0);
    var vol_txt = "VOLUME: " + string(master_volume) + "%";
    
    if (is_vol) {
        draw_set_color(c_sel);
        draw_text_transformed(gui_w / 2, vol_y + font_fix_y, "> " + vol_txt + " <", 3.5, 3.5, 0);
    } else {
        draw_set_color(c_norm);
        draw_text_transformed(gui_w / 2, vol_y + font_fix_y, vol_txt, 2, 2, 0);
    }

    // -- RESOLUTION --
    var res_y = content_y;
    var is_res = (settings_selected == 1);
    var res_txt = "RESOLUTION: " + resolution_list[current_resolution];
    
    if (is_res) {
        draw_set_color(c_sel);
        draw_text_transformed(gui_w / 2, res_y + font_fix_y, "> " + res_txt + " <", 3.5, 3.5, 0);
    } else {
        draw_set_color(c_norm);
        draw_text_transformed(gui_w / 2, res_y + font_fix_y, res_txt, 2, 2, 0);
    }

    // -- FULLSCREEN --
    var fs_y = content_y + 120;
    var is_fs = (settings_selected == 2);
    var fs_txt = "FULLSCREEN: " + (fullscreen_enabled ? "ON" : "OFF");
    
    if (is_fs) {
        draw_set_color(c_sel);
        draw_text_transformed(gui_w / 2, fs_y + font_fix_y, "> " + fs_txt + " <", 3.5, 3.5, 0);
    } else {
        draw_set_color(c_norm);
        draw_text_transformed(gui_w / 2, fs_y + font_fix_y, fs_txt, 2, 2, 0);
    }

    // --- 3. FOOTER ---
    var footer_w = 950;
    var footer_h = 80;
    var footer_x = gui_w / 2 - footer_w / 2;
    var footer_y = gui_h - 100;

    draw_set_color(c_box_bg);
    draw_rectangle(footer_x, footer_y - footer_h/2, footer_x + footer_w, footer_y + footer_h/2, false);
    draw_set_color(c_border);
    draw_rectangle(footer_x, footer_y - footer_h/2, footer_x + footer_w, footer_y + footer_h/2, true);

    draw_set_color(c_white);
    var footer_ctrl_y = footer_y - 30;
    var footer_ctrl_scale = 1.5;
    
    draw_text_transformed(gui_w / 2, footer_ctrl_y + font_fix_y, "[W/S] Select   [A/D] Change   [ENTER] Toggle   [ESC] Back", footer_ctrl_scale, footer_ctrl_scale, 0);
}

// ================= CONTROLS =================
else if (menu_state == "controls") {

    // --- 1. NADPIS ---
	var title_w = 1100; 
    var title_h = 280; 
    var title_x = gui_w / 2 - title_w / 2;
    var title_y = gui_h * 0.19;

    draw_set_color(c_box_bg);
    draw_rectangle(title_x, title_y - title_h/2, title_x + title_w, title_y + title_h/2, false);
    draw_set_color(c_border);
    draw_rectangle(title_x, title_y - title_h/2, title_x + title_w, title_y + title_h/2, true);

    draw_set_color(c_yellow);
    draw_text_transformed(gui_w / 2, title_y + font_fix_y, "Controls", 7, 7, 0);


    // --- 2. OBSAH ---
    var content_w = 800; 
    var content_h = 560; 
    var content_x = gui_w / 2 - content_w / 2;
    var content_y = gui_h * 0.60;

    draw_set_color(c_box_bg);
    draw_rectangle(content_x, content_y - content_h/2, content_x + content_w, content_y + content_h/2, false);
    draw_set_color(c_border);
    draw_rectangle(content_x, content_y - content_h/2, content_x + content_w, content_y + content_h/2, true);

    // Controls seznam
    draw_set_color(c_white);
    var ctrl_start_y = content_y - 130;
    var ctrl_spacing = 60;
    var ctrl_scale = 2.5;
    
    draw_text_transformed(gui_w / 2, ctrl_start_y + font_fix_y, "Move: WASD / Arrows", ctrl_scale, ctrl_scale, 0);
    draw_text_transformed(gui_w / 2, ctrl_start_y + ctrl_spacing + font_fix_y, "Jump: Space ", ctrl_scale, ctrl_scale, 0);
    draw_text_transformed(gui_w / 2, ctrl_start_y + ctrl_spacing*2 + font_fix_y, "Dash: F", ctrl_scale, ctrl_scale, 0);
    draw_text_transformed(gui_w / 2, ctrl_start_y + ctrl_spacing*3 + font_fix_y, "Attack: Z / Mouse 1", ctrl_scale, ctrl_scale, 0);
	draw_text_transformed(gui_w / 2, ctrl_start_y + ctrl_spacing*4 + font_fix_y, "Weapons: 1-5", ctrl_scale, ctrl_scale, 0);

    // --- 3. FOOTER ---
    var footer_w = 950;
    var footer_h = 80;
    var footer_x = gui_w / 2 - footer_w / 2;
    var footer_y = gui_h - 100;

    draw_set_color(c_box_bg);
    draw_rectangle(footer_x, footer_y - footer_h/2, footer_x + footer_w, footer_y + footer_h/2, false);
    draw_set_color(c_border);
    draw_rectangle(footer_x, footer_y - footer_h/2, footer_x + footer_w, footer_y + footer_h/2, true);

    draw_set_color(c_white);
    var footer_ctrl_y = footer_y - 30;
    var footer_ctrl_scale = 1.5;
    
    draw_text_transformed(gui_w / 2, footer_ctrl_y + font_fix_y, "[ESC] Back", footer_ctrl_scale, footer_ctrl_scale, 0);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);