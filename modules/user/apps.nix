{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Internet pretraživači
    brave
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Tekst editor
    zed-editor
    nixd              # Nix language server za Zed (autocomplete i greške)
    nixfmt-rfc-style  # Formatiranje Nix fajlova

    # Terminal
    ghostty

    # Multimedija (Video, muzika, slike)
    mpv      # Ultra lagan video plejer, savršen za Linux
    yt-dlp   # Skidanje i strimovanje YouTube videa direktno u mpv
    amberol  # Prelep, čist muzički plejer za lokalne pesme
    loupe    # Brz i moderan pregledač slika

    # Office i čitači fajlova
    libreoffice-fresh  # Najbolja besplatna zamena za Word/Excel
    evince             # Čitač PDF dokumenata
    kdePackages.ark    # Otvaranje arhiva (.zip, .rar, .7z) sa integracijom u Dolphin

    # Ostalo
    qbittorrent  # Torrent za skidanje

    # Git alati
    git
    gh

    # Sistemski alati
    fastfetch
    btop
    wl-clipboard  # Wayland clipboard podrška (potrebna mnogim alatima)

    # KDE alati
    kdePackages.spectacle  # Screenshot alat
  ];
}
