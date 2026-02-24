
if (instance_exists(Oplayer)) {
    instance_destroy(Oplayer);
}

if (instance_exists(Owave_manager)) {
    instance_destroy(Owave_manager);
}

if (instance_exists(Ohud)) {
    instance_destroy(Ohud);
}

if (instance_exists(Oenemy)) instance_destroy(Oenemy);
if (instance_exists(Oprojectile)) instance_destroy(Oprojectile);
