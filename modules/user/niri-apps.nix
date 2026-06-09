{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # File manager
    thunar  # GUI file manager

    # Screenshot (isti kao na KDE)
    kdePackages.spectacle

    # Wayland session alati
    grim        # Screenshot alat
    slurp       # Selekcija regiona ekrana (koristi se sa grim)
    wl-clipboard # Clipboard podrška (već u apps.nix ali sigurnost)

    # Autentikacija (potrebno bez KDE)
    polkit-kde-agent  # Polkit agent za autorizaciju

    # Wallpaper
    swww  # Wallpaper daemon za Wayland

    # Logout/session
    wlogout  # Meni za logout, reboot, shutdown
  ];
}
