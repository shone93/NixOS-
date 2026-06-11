# ─────────────────────────────────────────────
# PLACEHOLDER - ZAMENI OVO!
# Kada instaliraš NixOS na desktop (SolidSnake), pokreni:
#   sudo nixos-generate-config
# pa kopiraj /etc/nixos/hardware-configuration.nix preko ovog fajla.
# Bez pravog hardware-configuration.nix, SolidSnake se NEĆE buildovati.
# ─────────────────────────────────────────────
{ lib, ... }:

{
  # Minimalni placeholder da flake može da se evaluira.
  # Ovo NIJE dovoljno za stvarni boot - mora prava verzija.
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
