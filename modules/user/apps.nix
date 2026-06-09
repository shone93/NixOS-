{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Internet pregledači
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Tekst editor
    zed-editor
    nixd # Nix language server za Zed (autocomplete i greške)
    nixfmt # Formatiranje Nix fajlova

    # Terminal
    ghostty

    # Multimedija (Video, muzika, slike)
    mpv # Ultra lagan video plejer
    yt-dlp # Skidanje i strimovanje YouTube videa direktno u mpv
    amberol # Muzički plejer za lokalne pesme
    loupe # Pregledač slika

    # Office i čitači fajlova
    libreoffice-fresh # Zamena za Word/Excel
    evince # Čitač PDF dokumenata

    # Komunikacija
    keepassxc # Menadžer lozinki

    # Ostalo
    qbittorrent # Torrent klijent

    # Git alati
    git
    gh

    # Sistemski alati
    fastfetch
    btop
    wl-clipboard # Wayland clipboard podrška
    winetricks # Wine pomoćni alat za igre

    # Screenshot (radi na KDE i Niri)
    kdePackages.spectacle

    # Fontovi
    nerd-fonts.jetbrains-mono # Trenutno koristiš u Ghostty
    nerd-fonts.caskaydia-cove # Chris Titus favorit - Cascadia Code sa ikonama
    nerd-fonts.fira-code # Popularan sa ligaturama
    noto-fonts # Glavni sistemski font
    noto-fonts-emoji # Emoji podrška
  ];
}
