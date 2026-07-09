{ ... }:

{
  imports = [
    ./global.nix
    ./linux.nix
  ];

  programs.plasma.workspace.wallpaper = ../wallpapers/lizzy-Stardew.jpg;
}
