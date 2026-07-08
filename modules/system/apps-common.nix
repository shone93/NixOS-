{ pkgs, inputs, ... }:

{

  nixpkgs.overlays = [
    inputs.yazi-plugins.overlays.default
    inputs.yazi-flavors.overlays.default
    inputs.nix-topology.overlays.default
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
    ffmpeg # konverzija/merge audio+video (yt-dlp ga koristi za spajanje)
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
    eza # moderan `ls` (ikone, git status, boje)
    claude-code # AI kod editor

    # Git alati
    git
    gh

    # Sistemski alati
    nh # nix-helper: lepši `nh os switch` (vidi NH_FLAKE nize)
    fastfetch
    btop
    ncdu # disk usage TUI (gde je nestao prostor)
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

  # nh (nix-helper) cita NH_FLAKE — pa `nh os switch` radi bez extra flagova
  # i ne mora da mu se prosledjuje putanja do flake-a. Postoji UZ postojece
  # `rebuild`/`update` aliase (nije zamena) — vidi home/whitewolf/global.nix.
  environment.sessionVariables.NH_FLAKE = "/home/whitewolf/Documents/nixos-config";
}
