draw_set_alpha(alpha);

// Pokud je to sprite (ghost efekt)
if (is_sprite && sprite_index != -1) {
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, 1, 0, particle_color, alpha * 0.5);
} else {
    // Normální kruh
    draw_set_color(particle_color);
    draw_circle(x, y, size * 3, false);
}

// Reset
draw_set_alpha(1);
draw_set_color(c_white);