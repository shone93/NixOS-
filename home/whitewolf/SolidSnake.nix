{ ... }:

{
  # WhiteWolf na desktopu (SolidSnake)
  imports = [
    ./global.nix
    ./linux.nix
  ];

  # Ultrawide wallpaper
  programs.plasma.workspace.wallpaper = ../wallpapers/whitewolf-SolidSnake.jpg;
}
