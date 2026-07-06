{ ... }:

{
  # Lizzy na desktopu (SolidSnake)
  imports = [
    ./global.nix
    ./linux.nix
  ];

  programs.plasma.workspace.wallpaper = ../wallpapers/lizzy-SolidSnake.jpg;
}
