{ pkgs, ... }:

{
  # ─────────────────────────────────────────────
  # Niri kompozitor - NE importuje se još.
  # Kada budeš spreman, dodaj u flake.nix systemModules
  # za host na kome želiš Niri (najpre Stardew).
  # ─────────────────────────────────────────────
  programs.niri.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
    ];
    config.common.default = "*";
  };

  environment.systemPackages = with pkgs; [
    xdg-utils
    xdg-user-dirs
  ];
}
