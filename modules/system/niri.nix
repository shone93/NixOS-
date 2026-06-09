{ pkgs, ... }:

{
  # ─────────────────────────────────────────────
  # Niri kompozitor
  # ─────────────────────────────────────────────
  programs.niri = {
    enable = true;
  };

  # XDG portal za Wayland (potrebno za screen share, file picker itd.)
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome # Radi dobro sa Niri
    ];
    config.common.default = "*";
  };

  environment.systemPackages = with pkgs; [
    xdg-utils
    xdg-user-dirs
  ];
}
