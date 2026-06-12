{ ... }:

{
  # ─────────────────────────────────────────────
  # Syncthing - sinhronizacija fajlova između mašina
  # Koristi se za Obsidian vault, dokumente itd.
  # ─────────────────────────────────────────────
  services.syncthing = {
    enable = true;
    user = "whitewolf";
    dataDir = "/home/whitewolf";
    configDir = "/home/whitewolf/.config/syncthing";
    openDefaultPorts = true;
  };
}
