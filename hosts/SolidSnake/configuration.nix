{ ... }:

{
  # ─────────────────────────────────────────────
  # SolidSnake - Desktop (GTX 1080)
  # NAPOMENA: hardware-configuration.nix još ne postoji.
  # Kada instaliraš NixOS na desktop, pokreni:
  #   sudo nixos-generate-config
  # i kopiraj generisani hardware-configuration.nix u ovaj folder.
  # ─────────────────────────────────────────────

  networking.hostName = "SolidSnake";

  # Ovde dodaj diskove specifične za desktop kada ga budeš pravio,
  # npr. games disk po UUID-u (drugačiji UUID nego laptop).
}
