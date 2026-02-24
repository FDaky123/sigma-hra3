// Movement
x += vel_x;
y += vel_y;
vel_y += gravity_force;

// Friction
vel_x *= 0.95;

// Lifetime
lifetime--;
if (lifetime <= 0) {
    instance_destroy();
    exit;
}

// Fade out
if (fade_out) {
    alpha = lifetime / max_lifetime;
}

// Shrink
size = (lifetime / max_lifetime) * image_xscale;