// Pokud boss neexistuje, smaž UI
if (!instance_exists(Oboss)) {
    instance_destroy();
}