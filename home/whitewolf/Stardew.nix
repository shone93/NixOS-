{ ... }:

{
  imports = [
    ./global.nix
    ./linux.nix
  ];

  programs.plasma.workspace.wallpaper = ../wallpapers/whitewolf-Stardew.jpg;

  programs.plasma.kscreenlocker.appearance.wallpaper = ../wallpapers/whitewolf-Stardew.jpg;
}
