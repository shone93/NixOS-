{ pkgs, ... }:

{
  # ─────────────────────────────────────────────
  # Niri aplikacije - NE importuje se još.
  # Dodaj u flake.nix za host sa Niri kad budeš spreman.
  # ─────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    thunar # GUI file manager
    yazi # Terminal file manager
    grim # Screenshot
    slurp # Selekcija regiona
    polkit-kde-agent # Polkit agent
    swww # Wallpaper daemon
    wlogout # Logout meni
  ];
}
