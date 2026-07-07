{ ... }:

{
  # WhiteWolf na novom laptopu (Evangelion) - jedini korisnik.
  imports = [
    ./global.nix
    ./linux.nix
  ];

  # TODO: dodaj home/wallpapers/whitewolf-Evangelion.jpg pa prebaci putanju ovde.
  # Za sada koristi Stardew wallpaper kao placeholder.
  programs.plasma.workspace.wallpaper = ../wallpapers/whitewolf-Stardew.jpg;
  programs.plasma.kscreenlocker.appearance.wallpaper = ../wallpapers/whitewolf-Stardew.jpg;
}
