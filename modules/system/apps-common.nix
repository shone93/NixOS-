{ pkgs, inputs, ... }:

{

  nixpkgs.overlays = [
    inputs.yazi-plugins.overlays.default
    inputs.yazi-flavors.overlays.default
    inputs.nix-topology.overlays.default
  ];

  environment.systemPackages = with pkgs; [
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    zed-editor
    nixd # Nix language server
    nixfmt

    ghostty

    mpv
    yt-dlp # YouTube download/stream
    ffmpeg # yt-dlp ga koristi za spajanje audio+video
    amberol
    loupe

    libreoffice-fresh

    keepassxc

    python3
    obsidian
    syncthing
    nodejs # za koriscenje npm torlnk
    kdePackages.krohnkite
    ffmpegthumbnailer # video thumbnails
    poppler # PDF previews
    imagemagick
    fd
    ripgrep
    fzf
    eza
    claude-code

    git
    gh

    nh # nix-helper: lepši `nh os switch` (vidi NH_FLAKE nize)
    fastfetch
    btop
    ncdu # disk usage TUI (gde je nestao prostor)
    wl-clipboard
    winetricks

    kdePackages.spectacle

    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
    nerd-fonts.fira-code
    noto-fonts
    noto-fonts-color-emoji
  ];

  environment.sessionVariables.NH_FLAKE = "/home/whitewolf/Documents/nixos-config";
}
