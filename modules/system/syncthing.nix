{ ... }:

{
  # ─────────────────────────────────────────────
  # Syncthing - sinhronizacija fajlova između mašina
  # Koristi se za Obsidian vault, dokumente itd.
  # ─────────────────────────────────────────────
  services.syncthing = {
    enable = true;
    # TODO: confirm syncthing user for SolidSnake — lizzywizzy je primarni
    # korisnik na SolidSnake, ali syncthing ovde i dalje radi kao whitewolf.
    user = "whitewolf";
    dataDir = "/home/whitewolf";
    configDir = "/home/whitewolf/.config/syncthing";
    openDefaultPorts = true;
  };
}
