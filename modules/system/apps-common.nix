{ pkgs, inputs, ... }:

{

  nixpkgs.overlays = [
    inputs.yazi-plugins.overlays.default
    inputs.yazi-flavors.overlays.default
  ];

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

    # Komunikacija
    keepassxc # Menadžer lozinki

    # Ostalo
    python3
    obsidian
    syncthing
    nodejs # za koriscenje npm torlnk
    kdePackages.krohnkite
    ffmpegthumbnailer # video thumbnails
    poppler # PDF previews
    imagemagick # image handling
    fd # brže pretraživanje fajlova
    ripgrep # brzo pretraživanje sadržaja
    fzf # fuzzy finder integracija
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
