{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # File manager
    thunar # GUI file manager

    # Screenshot (isti kao na KDE)
    kdePackages.spectacle

    # Wayland session alati
    grim # Screenshot alat
    slurp # Selekcija regiona ekrana (koristi se sa grim)
    wl-clipboard # Clipboard podrška (već u apps.nix ali sigurnost)

    # Autentikacija (potrebno bez KDE)
    polkit-kde-agent # Polkit agent za autorizaciju

    # Wallpaper
    swww # Wallpaper daemon za Wayland

    # Logout/session
    wlogout # Meni za logout, reboot, shutdown
  ];

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "$HOME/Desktop";
    documents = "$HOME/Documents";
    download = "$HOME/Downloads";
    music = "$HOME/Music";
    pictures = "$HOME/Pictures";
    videos = "$HOME/Videos";
    templates = "$HOME/Templates";
    publicShare = "$HOME/Public";
  };

}
