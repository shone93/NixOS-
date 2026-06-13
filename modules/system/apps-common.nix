{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Internet pregledači
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Tekst editor
    zed-editor
    nixd # Nix language server
    nixfmt # Formatiranje Nix fajlova

    # Terminal
    ghostty

    # Multimedija
    mpv # Video plejer
    yt-dlp # YouTube download/stream
    amberol # Muzički plejer
    loupe # Pregledač slika

    # Office i čitači
    libreoffice-fresh
    evince # PDF

    # Komunikacija
    keepassxc # Menadžer lozinki

    # Ostalo
    python3
    qbittorrent
    obsidian
    syncthing

    # Git alati
    git
    gh

    # Sistemski alati
    fastfetch
    btop
    wl-clipboard
    winetricks

    # Screenshot (radi na KDE i Niri)
    kdePackages.spectacle

    # Fontovi
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
    nerd-fonts.fira-code
    noto-fonts
    noto-fonts-color-emoji
  ];
}
