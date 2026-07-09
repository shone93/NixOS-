{ ... }:

{
  imports = [
    ./global.nix
    ./linux.nix
  ];

  programs.plasma.workspace.wallpaper = ../wallpapers/whitewolf-SolidSnake.jpg;
}
