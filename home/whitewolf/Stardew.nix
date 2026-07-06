{ ... }:

{
  # WhiteWolf na laptopu (Stardew)
  imports = [
    ./global.nix
    ./linux.nix
  ];

  programs.plasma.workspace.wallpaper = ../wallpapers/whitewolf-Stardew.jpg;

  # Lock screen koristi istu sliku kao desktop
  programs.plasma.kscreenlocker.appearance.wallpaper = ../wallpapers/whitewolf-Stardew.jpg;
}
